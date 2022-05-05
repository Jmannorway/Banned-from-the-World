extends CharacterState

func enter():
	pass

func process(delta: float) -> String:
	if Input.is_action_pressed("run"):
		character.set_move_speed(character.run_speed)
	else:
		character.set_move_speed(character.walk_speed)
	
	var _input_vector = Player2D.make_input_vector_4way(Player2D.get_input_vector())
	if !Util.compare_v2(_input_vector, 0):
		if character.check_solid_relative(_input_vector): # check_solid_direction(_input_vector, get_input_index()):
			character.set_facing(_input_vector)
		else:
			character.queue_move(_input_vector)
			return "move"
	return ""

func exit():
	pass
