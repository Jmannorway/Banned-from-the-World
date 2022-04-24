extends ResourceGrid2D

class_name SolidGrid2D

export(bool) var as_navigation
var world_solid_grid 
var world_navigation_grid

const FREE_CELL = 0

enum SolidBit {
	STATIC,
	DYNAMIC}

func _enter_tree():
	world_solid_grid = WorldGrid.get_solid_grid(layer)
	world_navigation_grid = WorldGrid.get_navigation_grid(layer)
	if as_navigation:
		add_cell_function = "_add_cell_to_world_grid_nav"
		clear_cell_function = "_clear_cell_in_world_grid_nav"

# For use with integer position
func set_solid(ipos : Vector2, solid : bool, bit : int) -> void:
	set_cellv(ipos, Util.int_set_bit(get_cellv(ipos), bit, solid))

# For use with global position
func set_solid_at_pixel(gpos : Vector2, solid : bool, bit : int) -> void:
	set_solid(world_to_map(gpos), solid, bit)

func get_solid(ipos : Vector2) -> bool:
	return get_cellv(ipos) > 0

func get_solid_at_pixel(gpos : Vector2) -> bool:
	return get_cellv(world_to_map(gpos)) > 0

func move_solid(ipos : Vector2, imove : Vector2, bit : int = SolidBit.DYNAMIC) -> void:
	set_solid(ipos, false, bit)
	set_solid(ipos + imove, true, bit)

# For use with global position
func move_solid_to_pixel(var gpos: Vector2, var dist: Vector2, bit : int = SolidBit.DYNAMIC) -> void:
	set_solid_at_pixel(gpos, false, bit)
	set_solid_at_pixel(gpos + dist, true, bit)

# INTERNAL FUNCTIONS
func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_solid_grid.set_cell(world_x, world_y, get_cell(x, y))

func _add_cell_to_world_grid_nav(x : int, y : int, world_x : int, world_y : int):
	_add_cell_to_world_grid(x, y, world_x, world_y)
	world_navigation_grid.set_cell(world_x, world_y, (get_cell(x, y) + 1) * -1)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_solid_grid.set_cell(world_x, world_y, FREE_CELL)

func _clear_cell_in_world_grid_nav(x : int, y : int, world_x : int, world_y : int):
	_clear_cell_in_world_grid(x, y, world_x, world_y)
	world_navigation_grid.set_cell(world_x, world_y, FREE_CELL)
