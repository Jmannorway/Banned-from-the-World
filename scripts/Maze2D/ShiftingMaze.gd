tool

extends Node2D

export(Vector2) var size = Vector2(480,480)
export(int) var autotile_tile_index := 0
export(Vector2) var entrance_size # TODO: Implement entrance carving feature
export(bool) var do_reset setget set_reset
export(PackedScene) var moving_wall_scene
export(PackedScene) var enemy_scene
export(int, 0, 10) var enemies = 6
export(float, 0.1, 16.0) var shift_speed = 1.0
export(Vector2) var empty_autotile_coord = Vector2(10, 1)
export(bool) var looping = false setget set_looping
export(bool) var active = false setget set_active
export(int, 0, 50) var holes = 20

export(int, 1, 16) var offset_min = 4 setget set_offset_min
export(int, 1, 16) var offset_max = 6 setget set_offset_max
export(int, 4, 16) var separation_min = 4 setget set_separation_min
export(int, 4, 16) var separation_max = 6 setget set_separation_max

func set_looping(val : bool) -> void:
	if val:
		bitgrid = bitgrid_looping
	else:
		bitgrid = bitgrid_non_looping
	looping = val
	reset()

func set_active(val : bool) -> void:
	reset()
	
	if val && $interval.is_stopped():
		$interval.start()
	
	active = val

func set_offset_min(val : int) -> void:
	offset_min = min(val, offset_max)

func set_offset_max(val : int) -> void:
	offset_max = max(val, offset_min)

func set_separation_min(val : int) -> void:
	separation_min = min(val, separation_max)

func set_separation_max(val : int) -> void:
	separation_max = max(val, separation_min)

# temporary function to test maze in editor
func set_reset(val):
	generate_maze()
	reset()






var maze := Maze2D.new()
var bitgrid : BitGrid2D
var bitgrid_looping := BitGrid2D.new()
var bitgrid_non_looping := BitGrid2D.new()
var shifting_wall_speed := 2.0

onready var wall_tiles : TileMap = $walls
onready var moving_wall_tiles : TileMap = $moving_walls
onready var floor_tiles : TileMap = $floor
onready var moving_floor_tiles : TileMap = $moving_floor

func _ready():
	generate_maze()
	reset()
	
	if !Engine.editor_hint && active:
		$interval.start()

func _process(delta):
	var _camera = Util.get_first_node_in_group(get_tree(), "camera")
	if !Engine.editor_hint && !looping && _camera:
		var _loop_area = Util.get_first_node_in_group(get_tree(), "loop_area")
		if !_loop_area.get_rect().intersects(_camera.room_view):
			set_looping(true)
			set_active(true)
			create_maze_enemies()

func reset():
	reset_navigation_and_solids()
	reset_moving_walls()
	reset_visuals()

# internal utility
func generate_maze():
	maze.make_maze_recursive_backtrack(Util.floor_v2(size / Game.SNAP) / 2)
	
	# Make random holes
	var _maze_size = maze.size()
	var _pos
	var _moves : Array
	for i in holes:
		_pos = Vector2((randi() % int(_maze_size.x - 2)) + 1, (randi() % int(_maze_size.y - 2)) + 1)
		
		for j in Maze2D.DIRECTION._MAX:
			if !maze.has_hole(_pos, j):
				_moves.push_back(j)
		
		if _moves.size() > 0:
			maze.drill_hole(
				_pos,
				_moves[randi() % _moves.size()])
		
		_moves.clear()
	
	bitgrid_looping.create_from_maze(maze)

	# Make looping
	bitgrid_looping.resize(bitgrid_looping.size() - Vector2(2, 2))
	generate_maze_loop_holes(bitgrid_looping)
	bitgrid_looping.resize(bitgrid_looping.size() - Vector2.ONE)
	
	# Make non-looping (only vertically looping)
	bitgrid_non_looping.data = bitgrid_looping.data.duplicate(true)
	bitgrid_non_looping.set_area(
		Rect2(Vector2.ZERO,
		Vector2(1, bitgrid_looping.size().y)),
		true)
	
	# Punch holes in bitgrids using data from areas
	create_maze_holes(bitgrid_looping)
	create_maze_holes(bitgrid_non_looping)
	
	# Set the non-looping variant to be used at first
	bitgrid = bitgrid_non_looping

func create_maze_holes(bg : BitGrid2D):
	var _holes = get_tree().get_nodes_in_group("maze_hole")
	for n in _holes:
		bg.set_area(n.get_integer_rect(), false)

func generate_maze_loop_holes(bitgrid : BitGrid2D):
	var _size = bitgrid.size()
	for x in _size.x:
		bitgrid.data[x][0] *= bitgrid.data[x][_size.y - 1]
	for y in _size.y:
		bitgrid.data[0][y] *= bitgrid.data[_size.x - 1][y]

func create_moving_wall_entity(ipos : Vector2, dir := Vector2.DOWN) -> Character2DBase:
	var _moving_wall = moving_wall_scene.instance()
	_moving_wall.set_integer_position(ipos)
	_moving_wall.set_move_speed(shift_speed)
	_moving_wall.direction = dir
	add_child(_moving_wall)
	return _moving_wall

func create_maze_enemies() -> void:
	var _ipos
	var _pos
	var _spawned := false
	var _tries := 0
	var _camera = Util.get_first_node_in_group(get_tree(), "camera")
	var _bitgrid_size = bitgrid.size()
	
	for i in enemies:
		while !_spawned:
			_tries += 1
			_ipos = Vector2(randi() % int(_bitgrid_size.x), randi() % int(_bitgrid_size.y))
			_pos = _ipos * Game.SNAP + Vector2.ONE * Game.SNAP / 2
			if !bitgrid.data[_ipos.x][_ipos.y] && !_camera.room_view.has_point(_pos):
				var _enemy = enemy_scene.instance()
				_enemy.position = _pos
				add_child(_enemy)
				_spawned = true
		_spawned = false

func move_shifting_wall_tiles(block_distance : int, horizontal := false):
	var _duration = Character2DBase.get_travel_duration(abs(block_distance), shift_speed)
	var _property = "position:x" if horizontal else "position:y"
	$shifting_wall_tween.interpolate_property(
		moving_wall_tiles, _property, 0, block_distance * Game.SNAP, _duration)
	$shifting_wall_tween.interpolate_property(
		moving_floor_tiles, _property, 0, block_distance * Game.SNAP, _duration)
	$shifting_wall_tween.start()

func create_random_shifting_walls() -> void:
	var _separation = Util.randi_range(separation_min, separation_max)
	var _off_min = max(_separation, offset_min)
	var _off_max = min(_separation, offset_max)
	
	create_shifting_walls(
		Util.randi_range(_off_min, _off_max),
		_separation,
		true if randf() >= 0.5 else false,
		1 if randf() >= 0.5 else -1)

func create_shifting_walls(offset : int, separation : int, horizontal : bool, direction : int) -> void:
	var _bitgrid_size := bitgrid.size()
	var _xrange
	var _yrange
	var _travel
	var _direction
	
	if horizontal:
		offset = clamp(offset, 1, _bitgrid_size.x - 1)
		_xrange = _bitgrid_size.x
		_yrange = range(offset, _bitgrid_size.y - offset, separation)
		_travel = _bitgrid_size.x * sign(direction)
		_direction = Vector2.RIGHT * sign(direction)
	else:
		offset = clamp(offset, 1, _bitgrid_size.y - 1)
		_xrange = range(offset, _bitgrid_size.x - offset, separation)
		_yrange = _bitgrid_size.y
		_travel = _bitgrid_size.y * sign(direction)
		_direction = Vector2.DOWN * sign(direction)
	
	for x in _xrange:
		for y in _yrange:
			# Create moving tile entities on solids
			var _pos = Vector2(x, y)
			var _off_pos = _pos + _bitgrid_size * _direction * -1.0
			
			if bitgrid.data[x][y]:
				create_moving_wall_entity(_pos, _direction)
				create_moving_wall_entity(_off_pos, _direction)
			
			var _acoord = wall_tiles.get_cell_autotile_coord(x, y)
			
			wall_tiles.set_cellv(_pos, TileMap.INVALID_CELL)
#			floor_tiles.set_cellv(_pos, TileMap.INVALID_CELL)
			moving_wall_tiles.set_cellv(_pos, autotile_tile_index, false, false, false, _acoord)
			moving_wall_tiles.set_cellv(_off_pos, autotile_tile_index, false, false, false, _acoord)
			moving_floor_tiles.set_cellv(_pos, 0)
			moving_floor_tiles.set_cellv(_off_pos, 0)
			$solids.set_cellv(_pos, TileMap.INVALID_CELL)
			$navigation.set_cellv(_pos, 0)
	
	move_shifting_wall_tiles(_travel, horizontal)
	add_to_world_grid()

func add_to_world_grid() -> void:
	if !Engine.editor_hint:
		WorldGrid.clear_all()
	$navigation.paint_to_world_grid()
	$solids.paint_to_world_grid()

# Sub functions for resetting
func reset_navigation_and_solids():
	$solids.clear()
	$navigation.clear()
#	bitgrid.autotile_1($solids, 0)
#	bitgrid.autotile_1($navigation, 0)
	
	var _bitgrid_size = bitgrid.size()
	for x in _bitgrid_size.x:
		for y in _bitgrid_size.y:
			$solids.set_cell(x, y, bitgrid.data[x][y] - 1)
			$navigation.set_cell(x, y, (bitgrid.data[x][y] ^ 1) - 1)
	
	add_to_world_grid()

func reset_visuals():
	bitgrid.autotile_47(wall_tiles, autotile_tile_index, looping)
	var _bitgrid_size = bitgrid.size()
	for x in _bitgrid_size.x:
		for y in _bitgrid_size.y:
			floor_tiles.set_cell(x, y, 0)
			moving_floor_tiles.set_cell(x, y, TileMap.INVALID_CELL)
	reset_moving_walls()

func reset_moving_walls():
	if $shifting_wall_tween.is_active():
		$shifting_wall_tween.stop_all()
	
	moving_wall_tiles.clear()
	moving_wall_tiles.position = Vector2.ZERO
	
	var _moving_walls = get_tree().get_nodes_in_group("moving_wall")
	for _node in _moving_walls:
		_node.queue_free()

# signal callbacks
func _on_shifting_wall_tween_tween_all_completed():
	reset()
	$interval.start()

func _on_interval_timeout():
	create_random_shifting_walls()
