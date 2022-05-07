extends CharacterState

# This state treats the character variable as if it is player

func process(delta: float) -> String:
	if Input.is_action_pressed("run"):
		character.set_move_speed(character.run_speed)
	else:
		character.set_move_speed(character.walk_speed)
	
	# TODO: This is debug, remove. Player effects should change through the menu
	if Input.is_action_just_pressed("debug_test"):
		character.set_effect("")
		print(character.effect_state.get_current_state().name)
	
	var _input_vector = Player2D.make_input_vector_4way(Player2D.get_input_vector())
	if !Util.compare_v2(_input_vector, 0):
		if character.check_solid_relative(_input_vector): # check_solid_direction(_input_vector, get_input_index()):
			character.set_facing(_input_vector)
		else:
			character.queue_move(_input_vector)
			return "move"
	else:
		character.sprite.idle()
	
	# This line is absolutely disgusting but it works
	if Input.is_action_just_pressed("interact"):
		character.interactable_detector.interact_with_facing(
				character,
				character.calculate_move_offset(character.facing))
	
	return KEEP_STATE
