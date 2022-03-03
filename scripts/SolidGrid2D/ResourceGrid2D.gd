extends TileMap

class_name ResourceGrid2D

export(bool) var add_on_ready = true
export(bool) var hide_on_ready = true

func update_snap() -> void:
	cell_size = Vector2(Game.SNAP, Game.SNAP)

func paint_to_world_grid() -> void:
	call_on_used_rect("_add_cell_to_world_grid")

func erase_from_world_grid() -> void:
	call_on_used_rect("_clear_cell_in_world_grid")

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
