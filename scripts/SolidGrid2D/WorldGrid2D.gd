extends TileMap

func update_snap() -> void:
	cell_size = Vector2(Game.SNAP, Game.SNAP)

func _on_MapManager_MapChanged() -> void:
	clear()

func _ready():
	update_snap()
	MapManager.connect("changing_map", self, "_on_MapManager_MapChanged")
