extends YSort
tool

export(int) var layer : int setget set_layer
func set_layer(val : int) -> void:
	if val >= 0 && val < WorldGrid.LAYER_COUNT:
		z_index = val
		layer = val
	else:
		print("RoomLayer2D: Tried setting invalid layer")

func _ready() -> void:
	if !Engine.editor_hint:
		MapManager.get_room_manager().register_room_layer(self)
