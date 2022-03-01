extends Node2D

export(Vector2) var size = Vector2(480,480)
export(int) var autotile_tile_index := 0
export(Vector2) var entrance_size # TODO: Implement entrance carving feature
export(bool) var do_reset setget set_reset

# temporary function to test maze in editor
func set_reset(val):
	reset()
	create_shifting_wall(3)

var maze := RecursiveBacktrack.new()
var shifting_wall_speed := 2.0
var bitgrid : Array
var bitgrid_size : Vector2

onready var wall_tiles : TileMap = $walls
onready var floor_tiles : TileMap = $floor
onready var moving_wall_tiles : TileMap = $moving_walls
onready var moving_floor_tiles : TileMap = $moving_floor

func _ready():
	generate_maze()
	make_player_hole()
	reset()

func reset():
	reset_navigation_and_solids()
	reset_moving_walls()






# internal utility
func generate_maze():
	#generate a maze
	maze.make_maze(Util.floor_v2(size / Game.SNAP) / 2)
	bitgrid = maze.make_grid()
	bitgrid_size = Vector2(bitgrid.size(), bitgrid[0].size())

func create_shifting_wall(pos : int):
	var _cell
	for y in bitgrid_size.y:
		_cell = wall_tiles.get_cell_autotile_coord(pos, y)
		moving_floor_tiles.set_cell(pos, y, 0)
		moving_floor_tiles.set_cell(pos, y - bitgrid_size.y, 0)
		moving_wall_tiles.set_cell(pos, y, autotile_tile_index, false, false, false, _cell)
		moving_wall_tiles.set_cell(pos, y - bitgrid_size.y, autotile_tile_index, false, false, false, _cell)
		$solids.set_cell(pos, y, TileMap.INVALID_CELL)
		$navigation.set_cell(pos, y, 0)
	
	var _travel = bitgrid_size.y * Game.SNAP
	
	$shifting_wall_tween.interpolate_property(moving_wall_tiles, "position:y", 0, _travel,  bitgrid_size.y * shifting_wall_speed)
	$shifting_wall_tween.interpolate_property(moving_floor_tiles, "position:y", 0, _travel,  bitgrid_size.y * shifting_wall_speed)
	$shifting_wall_tween.start()

func make_player_hole():
	#create an entrance in the maze where the player is
	var player = PlayerAccess.get_player_2d(get_tree())
	if player:
		var pos = Util.absolute_to_relative_position(player, self)
		pos = Util.floor_v2(pos / Game.SNAP)
		bitgrid[0][pos.y - 1] = 0
		bitgrid[0][pos.y] = 0
		bitgrid[0][pos.y + 1] = 0

func add_to_world_grid() -> void:
	WorldGrid.clear_all()
	$navigation.paint_to_world_grid()
	$solids.paint_to_world_grid()

# Sub functions for resetting
func reset_navigation_and_solids():
	BitGridUtil.autotile_1_bitgrid(bitgrid, $solids, 0)
	BitGridUtil.autotile_1_bitgrid(bitgrid, $navigation, 0)
	add_to_world_grid()

func reset_visuals():
	BitGridUtil.autotile_47_bitgrid_wrap(bitgrid, wall_tiles, autotile_tile_index)
	for x in bitgrid.size():
		for y in bitgrid[x].size():
			floor_tiles.set_cell(x, y, 0)
	reset_moving_walls()

func reset_moving_walls():
	if $shifting_wall_tween.is_active():
		$shifting_wall_tween.stop()
	
	moving_floor_tiles.clear()
	moving_wall_tiles.clear()
	moving_wall_tiles.position = Vector2.ZERO
	moving_floor_tiles.position = Vector2.ZERO

# signal callbacks
func _on_shifting_wall_tween_tween_all_completed():
	reset_moving_walls()
