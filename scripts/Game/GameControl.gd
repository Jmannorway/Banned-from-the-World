extends AnimationPlayer

export(bool) var debug
export(String) var debug_animation_name

export(String) var opening_animation_name
export(String) var door_animation_name

func _ready():
	var _room_manager = Util.get_first_node_in_group(get_tree(), "room_manager") as RoomManager3D
	if debug:
		_room_manager.controllingCamera = false
		call_deferred("play", debug_animation_name)
	else:
		if Statistics.metadata.intro_finished:
			_room_manager.controllingCamera = true
		else:
			_room_manager.controllingCamera = false
			call_deferred("play", opening_animation_name)
	
	var _tutorial = get_node("../cutscene_nodes/tutorial")
	_tutorial.connect(
			"tutorial_finished",
			self,
			"_on_tutorial_tutorial_finished",
			[_tutorial])

func _on_door_interactable_interacted() -> void:
	play(door_animation_name)

func _on_cutscene_player_animation_finished(anim_name: String) -> void:
	pass
	if anim_name == door_animation_name:
		Statistics.metadata.intro_finished = true
		Statistics.write_meta_file()

func _on_tutorial_tutorial_finished(tutorial_node) -> void:
	play("opening_animation_2")
