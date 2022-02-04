extends ResourceGrid2D

class_name SolidGrid2D

func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.solid_grid.set_cell(world_x, world_y, get_cell(x, y))

func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.solid_grid.set_cell(world_x, world_y, INVALID_CELL)

func move_solid(var fromPosition: Vector2, var moveDirection: Vector2) -> void:
	var _gridFromPos: Vector2 = world_to_map(fromPosition)
	var _gridMovePos: Vector2 = world_to_map(fromPosition + moveDirection)
	
	set_cellv(_gridFromPos, TileMap.INVALID_CELL)
	set_cellv(_gridMovePos, 0)
