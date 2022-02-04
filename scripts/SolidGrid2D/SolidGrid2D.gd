extends TileMap

export var add_on_ready := true

func paint_to_world_grid() -> void:
	var area = get_used_rect()
	var offset = Util.floor_v2(global_position / Game.SNAP)
	
	for x in range(area.position.x, area.end.x):
		for y in range(area.position.y, area.end.y):
			var _tileID: int = get_cell(x, y)
			
			if _tileID == 0:
				WorldGrid.set_cell(x + offset.x, y + offset.y, _tileID)
			else:
				WorldGrid.set_navigation_cell(x + offset.x, y + offset.y, _tileID)

func _ready():
	visible = false
	if add_on_ready:
		paint_to_world_grid()
