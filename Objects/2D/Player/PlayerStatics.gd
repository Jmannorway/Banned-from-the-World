class_name PlayerStatics

static func get_input_vector_2d() -> Vector2:
	return Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

static func get_input_vector() -> Vector3:
	var input_vector = get_input_vector_2d()
	return Vector3(input_vector.x, 0, input_vector.y)
