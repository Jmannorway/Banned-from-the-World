extends ResourceGrid2D

class_name NavigationGrid2D

var world_navigation_grid

func _enter_tree() -> void:
	world_navigation_grid = WorldGrid.get_navigation_grid(layer)

func get_navigation_path(var from: Vector2, var to: Vector2) -> PoolVector2Array:
	var _path = WorldGrid.get_navigation(layer).get_simple_path(from, to, true)
	var _room_offset = MapManager.get_room_manager().get_current_room_loader().position
	for i in _path.size():
		_path[i] -= _room_offset
	return _path

func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_navigation_grid.set_cell(world_x, world_y, get_cell(x, y))

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_navigation_grid.set_cell(world_x, world_y, INVALID_CELL)
