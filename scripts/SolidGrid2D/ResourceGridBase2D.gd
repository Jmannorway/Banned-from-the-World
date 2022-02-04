extends TileMap

class_name ResourceGridBase2D

export var add_on_ready := true

func paint_to_world_grid() -> void:
	call_on_used_rect("_add_cell_to_world_grid")

func erase_from_world_grid() -> void:
	call_on_used_rect("_clear_cell_in_world_grid")

func call_on_used_rect(function_name : String) -> void:
	var area = get_used_rect()
	var offset = Util.floor_v2(global_position / Game.SNAP)
	
	for x in range(area.position.x, area.end.x):
		for y in range(area.position.y, area.end.y):
			call(function_name, x, y, offset)

func _ready():
	visible = false
	if add_on_ready:
		paint_to_world_grid()

func _add_cell_to_world_grid(x : int, y : int, offset : Vector2):
	WorldGrid.set_cell(x + offset.x, y + offset.y, get_cell(x, y))

func _clear_cell_in_world_grid(x : int, y : int, offset : Vector2):
	WorldGrid.set_cell(x + offset.x, y + offset.y, INVALID_CELL)
