extends ResourceGrid2D

class_name SolidGrid2D

func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.solid_grid.set_cell(world_x, world_y, get_cell(x, y))

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.solid_grid.set_cell(world_x, world_y, INVALID_CELL)

# For use with integer position
func set_solid(ipos : Vector2, solid : bool) -> void:
	set_cellv(ipos, 0 if solid else INVALID_CELL)

func set_solid_at_pixel(gpos : Vector2, solid : bool) -> void:
	set_solid(world_to_map(gpos), solid)

# For use with global position
func move_solid_to_pixel(var globalFromPosition: Vector2, var moveDirection: Vector2) -> void:
	set_solid_at_pixel(globalFromPosition, false)
	set_solid_at_pixel(globalFromPosition + moveDirection, true)

func move_solid(ipos : Vector2, imove : Vector2) -> void:
	set_solid(ipos, false)
	set_solid(ipos + imove, true)
