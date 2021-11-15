extends TileMap

func _on_Maze_done_generating(maze : Maze):
	var _grid = maze.generate_grid()
	for x in _grid.size():
		for y in _grid[x].size():
			set_cell(x, y, !_grid[x][y])
