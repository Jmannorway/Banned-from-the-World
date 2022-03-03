tool

extends Node2D

export(Vector2) var size = Vector2(480,480)
export(int) var autotile_tile_index := 0
export(Vector2) var entrance_size # TODO: Implement entrance carving feature
export(bool) var do_reset setget set_reset
export(PackedScene) var moving_wall_scene
export(float, 0.1, 16.0) var shift_speed = 1.0
export(Vector2) var empty_autotile_coord = Vector2(10, 1)

export(int, 1, 16) var offset_min = 4 setget set_offset_min
export(int, 1, 16) var offset_max = 6 setget set_offset_max
export(int, 4, 16) var separation_min = 4 setget set_separation_min
export(int, 4, 16) var separation_max = 6 setget set_separation_max

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
	reset()
	create_shifting_walls(3, 6, false, -1)

var maze := Maze2D.new()
var bitgrid := BitGrid2D.new()
var shifting_wall_speed := 2.0

onready var wall_tiles : TileMap = $walls
onready var moving_wall_tiles : TileMap = $moving_walls

func _ready():
	generate_maze()
	make_player_hole()
	reset()
	
	if !Engine.editor_hint:
		$interval.start()

func reset():
	reset_navigation_and_solids()
	reset_moving_walls()
	reset_visuals()

# internal utility
func generate_maze():
	maze.make_maze_recursive_backtrack(Util.floor_v2(size / Game.SNAP) / 2)
	bitgrid.create_from_maze(maze)
	bitgrid.resize(bitgrid.size() - Vector2(2, 2))
	loop_maze()
	bitgrid.resize(bitgrid.size() - Vector2.ONE)
	create_maze_holes()

func create_maze_holes():
	var _holes = get_tree().get_nodes_in_group("maze_hole")
	for n in _holes:
		bitgrid.make_hole(n.get_integer_rect())

func loop_maze():
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

func move_shifting_wall_tiles(block_distance : int, horizontal := false):
	var _duration = Character2DBase.get_travel_duration(abs(block_distance), shift_speed)
	$shifting_wall_tween.interpolate_property(
		moving_wall_tiles,
		"position:x" if horizontal else "position:y",
		0,
		block_distance * Game.SNAP,
		_duration)
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
			moving_wall_tiles.set_cellv(_pos, autotile_tile_index, false, false, false, _acoord)
			moving_wall_tiles.set_cellv(_off_pos, autotile_tile_index, false, false, false, _acoord)
			$solids.set_cellv(_pos, TileMap.INVALID_CELL)
			$navigation.set_cellv(_pos, 0)
	
	move_shifting_wall_tiles(_travel, horizontal)
	add_to_world_grid()

func make_player_hole():
	#create an entrance in the maze where the player is
	var player = PlayerAccess.get_player_2d(get_tree())
	if player:
		var pos = Util.absolute_to_relative_position(player, self)
		pos = Util.floor_v2(pos / Game.SNAP)
		bitgrid.data[0][pos.y - 1] = 0
		bitgrid.data[0][pos.y] = 0
		bitgrid.data[0][pos.y + 1] = 0

func add_to_world_grid() -> void:
	WorldGrid.clear_all()
	$navigation.paint_to_world_grid()
	$solids.paint_to_world_grid()

# Sub functions for resetting
func reset_navigation_and_solids():
	$solids.clear()
	$solids.clear()
	bitgrid.autotile_1($solids, 0)
	bitgrid.autotile_1($navigation, 0)
	add_to_world_grid()

func reset_visuals():
	bitgrid.autotile_47(wall_tiles, autotile_tile_index)
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
