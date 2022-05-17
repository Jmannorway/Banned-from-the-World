extends Interactable

class_name InteractableRoom

signal prevent_event(selfRoom)

export var roomName: String

func _interact(var roomManager) -> void:
	if Statistics.metadata["fog_stage"] < roomManager.rooms[roomName].unlockStage:
		emit_signal("prevent_event", self)
		return
	
	if !activatePlayerAnimation.empty():
		var _player = PlayerAccess.get_player_3d(get_tree())
		
		_player.anim.travel(activatePlayerAnimation)
		_player.set_frozen("book_animation", true)
		
		var _sceneTimer: SceneTreeTimer = get_tree().create_timer(_player.animPlayer.get_animation(activatePlayerAnimation).length, false)
		_sceneTimer.connect("timeout", self, "change_on_anim_finished", [ roomManager ])
		return
	
	change_on_anim_finished(roomManager)

func change_on_anim_finished(var roomManager) -> void:
	var _oldRoomName: String = roomManager.currentRoom.name
	var _toPosition: Vector3 = roomManager.request_room_change(roomName).grab_transition_postion(_oldRoomName)
	
	roomManager.mainCharacter.teleport_to(_toPosition)
	PlayerAccess.get_player_3d(get_tree()).set_frozen("book_animation", false)
