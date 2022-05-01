extends AnimationPlayer

export(bool) var debug
export(String) var starting_animation
export(bool) var start_on_ready
export(String) var door_cutscene_name

func _ready():
	var _room_manager = Util.get_first_node_in_group(get_tree(), "room_manager") as RoomManager3D
	if debug:
		_room_manager.controllingCamera = false
		if start_on_ready:
			print(44)
			call_deferred("play", starting_animation)
	else:
		if Statistics.metadata.intro_finished:
			_room_manager.controllingCamera = true
		else:
			_room_manager.controllingCamera = false
			call_deferred("play", "opening_cutscene")
#			play("opening_cutscene")
			print(42)
	
	var _tutorial = get_node("../cutscene_nodes/tutorial")
	_tutorial.connect(
			"transition_finished",
			self,
			"_on_tutorial_transition_finished",
			[_tutorial])

func _on_door_interactable_interacted() -> void:
	play(door_cutscene_name)

func _on_cutscene_player_animation_finished(anim_name: String) -> void:
	pass
	if anim_name == door_cutscene_name:
		Statistics.metadata.intro_finished = true
		Statistics.write_meta_file()

func _on_tutorial_transition_finished(tutorial_node) -> void:
	play("opening_animation_2")
