extends KinematicBody2D

class_name Player2D

var walk_speed : float = 100
var run_speed : float = 175
var current_speed : float

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

func _process(delta):
	var _input_vector = get_input_vector()
	
	if Input.is_action_pressed("run"):
		current_speed = run_speed
		$animated_sprite.speed_scale = 1.5
	else:
		current_speed = walk_speed
		$animated_sprite.speed_scale = 1.0
	
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
	
	if Input.is_action_just_pressed("interact"):
		$interactable_detector.interact_with_facing(global_position, _input_vector.normalized())

func _physics_process(delta):
	var _input_vector = get_input_vector()
	move_and_slide(_input_vector.normalized() * current_speed)
