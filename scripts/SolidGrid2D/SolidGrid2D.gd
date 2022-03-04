extends ResourceGrid2D

class_name SolidGrid2D

export(bool) var as_navigation

func _enter_tree():
	if as_navigation:
		add_cell_function = "_add_cell_to_world_grid_nav"
		clear_cell_function = "_clear_cell_in_world_grid_nav"

# For use with integer position
func set_solid(ipos : Vector2, solid : bool) -> void:
	set_cellv(ipos, 0 if solid else INVALID_CELL)

# For use with global position
func set_solid_at_pixel(gpos : Vector2, solid : bool) -> void:
	set_solid(world_to_map(gpos), solid)

func move_solid(ipos : Vector2, imove : Vector2) -> void:
	set_solid(ipos, false)
	set_solid(ipos + imove, true)

# For use with global position
func move_solid_to_pixel(var globalFromPosition: Vector2, var moveDirection: Vector2) -> void:
	set_solid_at_pixel(globalFromPosition, false)
	set_solid_at_pixel(globalFromPosition + moveDirection, true)



# INTERNAL FUNCTIONS
func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.solid_grid.set_cell(world_x, world_y, get_cell(x, y))

func _add_cell_to_world_grid_nav(x : int, y : int, world_x : int, world_y : int):
	_add_cell_to_world_grid(x, y, world_x, world_y)
	WorldGrid.navigation_grid.set_cell(world_x, world_y, (get_cell(x, y) + 1) * -1)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.solid_grid.set_cell(world_x, world_y, INVALID_CELL)

func _clear_cell_in_world_grid_nav(x : int, y : int, world_x : int, world_y : int):
	_clear_cell_in_world_grid(x, y, world_x, world_y)
	WorldGrid.navigation_grid.set_cell(world_x, world_y, INVALID_CELL)

func convert_solid_cell_to_nav(cell : int) -> int:
	return ((cell + 1) * -1)
