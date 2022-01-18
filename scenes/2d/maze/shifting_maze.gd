extends Node2D

var maze := RecursiveBacktrack.new()
export var size := Vector2(480,480)
export var grid := 24
export var autotile_tile_index := 0
var bitgrid : Array

func _ready():
	#generate a maze
	maze.make_maze(Util.snap_v2(size, grid))
	bitgrid = maze.make_grid()
	
	#create an entrance in the maze where the player is
	var player = Util.get_first_node_in_group(get_tree(), "player")
	if player:
		var pos = Util.absolute_to_relative_position(player, self)
		pos = Util.snap_v2(pos, 24)
		bitgrid[0][pos.y - 1] = 0
		bitgrid[0][pos.y] = 0
		bitgrid[0][pos.y + 1] = 0
	
	# set tiles
	BitGridUtil.autotile_47_bitgrid_wrap(bitgrid, $tiles, autotile_tile_index)
	BitGridUtil.autotile_1_bitgrid(bitgrid, $blocking_tilemap_24, 0)
	for x in bitgrid.size():
		for y in bitgrid[x].size():
			$floor_tiles.set_cell(x, y, 0)
	
