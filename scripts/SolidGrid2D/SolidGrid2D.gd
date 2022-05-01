extends ResourceGrid2D

class_name SolidGrid2D

export(bool) var as_navigation
var world_solid_grid 
var world_navigation_grid

func _enter_tree():
	world_solid_grid = WorldGrid.get_solid_grid(layer)
	world_navigation_grid = WorldGrid.get_navigation_grid(layer)
	if as_navigation:
		add_cell_function = "_add_cell_to_world_grid_nav"
		clear_cell_function = "_clear_cell_in_world_grid_nav"

# For use with integer position
func set_solid(ipos : Vector2, solid : int) -> void:
	set_cellv(ipos, solid)

# For use with global position
func set_solid_at_pixel(gpos : Vector2, solid : bool) -> void:
	set_solid(world_to_map(gpos), solid)

func move_solid(ipos : Vector2, imove : Vector2) -> void:
	set_solid(ipos, false)
	set_solid(ipos + imove, true)

# For use with global position
func move_solid_to_pixel(var gpos: Vector2, var dist: Vector2, var setTileIndex: int = INVALID_CELL) -> int:
	var _nextTileIndex: int = get_cellv(gpos + dist)
	
#	set_solid_at_pixel(gpos, setTileIndex)
#	set_solid_at_pixel(gpos + dist, 15) # solid = 15
	
	return _nextTileIndex

# INTERNAL FUNCTIONS
func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_solid_grid.set_cell(world_x, world_y, get_cell(x, y))

func _add_cell_to_world_grid_nav(x : int, y : int, world_x : int, world_y : int):
	_add_cell_to_world_grid(x, y, world_x, world_y)
	world_navigation_grid.set_cell(world_x, world_y, (get_cell(x, y) + 1) * -1)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_solid_grid.set_cell(world_x, world_y, INVALID_CELL)

func _clear_cell_in_world_grid_nav(x : int, y : int, world_x : int, world_y : int):
	_clear_cell_in_world_grid(x, y, world_x, world_y)
	world_navigation_grid.set_cell(world_x, world_y, INVALID_CELL)
