extends Interactable

class_name InteractableRoom

export var roomName: String
export var enableAxiety: bool
export var addPosition: Vector3

func _event(var player: CharacterController3D) -> void:
	if enableAxiety:
		player.anim.start("Deny")
	else:
		var _name: RoomManager3D = get_tree().current_scene
# warning-ignore:return_value_discarded
		_name.request_room_change(roomName)
		player.translation += addPosition
