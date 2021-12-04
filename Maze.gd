extends TileMap

var maze := Maze2D.new()
var grid : Array
var size := Vector2(320, 320)

func _enter_tree():
	var _maze_size = size / cell_size / 2
	maze.make_maze(_maze_size)
	grid = maze.make_grid()
	
	for x in grid.size():
		for y in grid[x].size():
			set_cell(x, y, grid[x][y] - 1)
