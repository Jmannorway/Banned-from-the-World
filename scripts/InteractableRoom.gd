extends Interactable

class_name InteractableRoom

export var roomName: String

func _event() -> void:
	var _name: RoomManager3D = get_tree().current_scene
# warning-ignore:return_value_discarded
	_name.request_room_change(roomName)
