extends Interactable

class_name InteractableRoom

signal prevent_event(selfRoom)

export var roomName: String

func _interact(var roomManager) -> void:
	if Statistics.metadata["fog_stage"] < roomManager.rooms[roomName].unlockStage:
		emit_signal("prevent_event", self)
		return
	
	var _oldRoomName: String = roomManager.currentRoom.name
	var _toPosition: Vector3 = roomManager.request_room_change(roomName).grab_transition_postion(_oldRoomName)
	
	roomManager.mainCharacter.teleport_to(_toPosition)
