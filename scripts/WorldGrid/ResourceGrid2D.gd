extends TileMap

class_name ResourceGrid2D

export(bool) var add_on_ready = true
export(bool) var hide_on_ready = true
export(int) var layer : int = 0 setget set_layer
func set_layer(val : int) -> void:
	if val < 0 || val >= WorldGrid.LAYER_COUNT:
		print("ResourceGrid2D: Invalid layer")
	else:
		layer = val

# These have to be set to a function with the correct signature
var add_cell_function : String = "_add_cell_to_world_grid"
var clear_cell_function : String = "_clear_cell_in_world_grid"

func update_snap() -> void:
	cell_size = Vector2(Game.SNAP, Game.SNAP)

func paint_to_world_grid() -> void:
	call_on_used_rect(add_cell_function)

func erase_from_world_grid() -> void:
	call_on_used_rect(clear_cell_function)

func call_on_used_rect(function_name : String) -> void:
	var area = get_used_rect()
	var offset = Util.floor_v2(global_position / Game.SNAP)
	
	for x in range(area.position.x, area.end.x):
		for y in range(area.position.y, area.end.y):
			call(function_name, x, y, x + offset.x, y + offset.y)

func _ready():
	if hide_on_ready:
		visible = false
	update_snap()
	if add_on_ready:
		paint_to_world_grid()

func get_cell_at_pixel(pos : Vector2) -> int:
	return get_cellv(world_to_map(pos))

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	pass # override this and add cell to the correct child of world grid

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	pass # override this and clear cell in the correct child of world grid
