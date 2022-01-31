extends TileMap

export var add_on_ready := true

func paint_to_world_grid() -> void:
	var area = get_used_rect()
	var offset = Util.floor_v2(global_position / Game.SNAP)
	print(area.size)
	for x in range(area.position.x, area.end.x):
		for y in range(area.position.y, area.end.y):
			SolidGrid.set_cell(x + offset.x, y + offset.y, get_cell(x, y))

func _ready():
	if add_on_ready:
		paint_to_world_grid()
