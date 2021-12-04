extends TileMap

var maze := Maze2D.new()
var grid : Array

func _ready():
	maze.make_maze(Vector2(8,8))
	grid = maze.make_grid()
	
	for x in grid.size():
		for y in grid[x].size():
			set_cell(x, y, grid[x][y] - 1)
