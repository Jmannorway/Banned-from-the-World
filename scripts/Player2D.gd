extends KinematicBody2D

var speed : float = 100

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

func _process(delta):
	var _input_vector = get_input_vector()
	
	if _input_vector.x == -1:
		$animated_sprite.play("left")
	elif _input_vector.x == 1:
		$animated_sprite.play("right")
	elif _input_vector.y == -1:
		$animated_sprite.play("up")
	elif _input_vector.y == 1:
		$animated_sprite.play("down")
	
	if _input_vector.is_equal_approx(Vector2.ZERO):
		$animated_sprite.idle()

func _physics_process(delta):
	var _input_vector = get_input_vector()
	move_and_slide(_input_vector.normalized() * speed)
