extends ResourceGrid2D

class_name NavigationGrid2D

func get_navigation_path(var from: Vector2, var to: Vector2) -> PoolVector2Array:
	return get_node("../").get_simple_path(from, to, true)

func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.navigation_grid.set_cell(world_x, world_y, get_cell(x, y))

func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.navigation_grid.set_cell(world_x, world_y, INVALID_CELL)
