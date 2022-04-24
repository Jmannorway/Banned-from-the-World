extends AnimationPlayer

func _ready():
	var _room_manager = Util.get_first_node_in_group(get_tree(), "room_manager") as RoomManager3D
	if Statistics.metadata.intro_finished:
		
		_room_manager.controllingCamera = true
	else:
		_room_manager.controllingCamera = false
		play("opening_cutscene")

func _on_door_interactable_interacted() -> void:
	play("opening_cutscene_2")


func _on_cutscene_player_animation_finished(anim_name: String) -> void:
	match anim_name:
		"opening_cutscene_2":
			Statistics.metadata.intro_finished = true
			Statistics.write_meta_file()
