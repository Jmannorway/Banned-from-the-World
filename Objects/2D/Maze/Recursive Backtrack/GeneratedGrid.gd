extends TileMap

func _on_Maze_done_generating(maze : Maze):
	var _grid = maze.generate_grid()
	for x in _grid.size():
		for y in _grid[x].size():
			set_cell(x, y, !_grid[x][y])

func _process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		var mpos = get_local_mouse_position()
		var cell = get_cellv(world_to_map(get_global_mouse_position()))
		if cell == INVALID_CELL:
			cell = 0
		else:
			cell = INVALID_CELL
		set_cellv(world_to_map(mpos), cell)
