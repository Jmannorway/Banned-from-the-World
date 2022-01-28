extends TileMap

var maze := RecursiveBacktrack.new()
var grid : Array
var size := Vector2(960, 960)
const SEED := 4983209750

var opening_size := 3
var opening_start := 5

func _ready():
	var _maze_size = size / cell_size / 2
	_maze_size.x = floor(_maze_size.x)
	_maze_size.y = floor(_maze_size.y)
	maze.make_maze(_maze_size)
	grid = maze.make_grid()
	
	for x in grid.size():
		for y in grid[x].size():
			set_cell(x, y, grid[x][y] - 1)
