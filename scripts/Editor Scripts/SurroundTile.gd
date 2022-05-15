extends EditorScript
tool

func _run() -> void:
	var _selection = get_editor_interface().get_selection().get_selected_nodes()
	if _selection.size() < 2 || _selection.size() > 2:
		printerr("Selection size be bigger or smaller than 2")
		return
	
	var solid_grid : SolidGrid2D = null
	for node in _selection:
		if node is SolidGrid2D:
			solid_grid = node
			break
	
	var tilemap : TileMap = null
	for node in _selection:
		if node is TileMap && node != solid_grid:
			tilemap = node
			break
	
	if !is_instance_valid(tilemap) || !is_instance_valid(solid_grid):
		printerr("Couldn't find a valid SolidGrid2D and TileMap in selection")
		return
	
	for pos in tilemap.get_used_cells():
		if tilemap.get_cellv(pos) == TileMap.INVALID_CELL:
			continue
		for dir in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
			if tilemap.get_cellv(pos + dir) == TileMap.INVALID_CELL:
				solid_grid.set_cellv(pos + dir, 0)
		
