extends Character2D

class_name Player2D

var walk_speed := 2.0
var run_speed := 4.0

signal move_finished(pos)

var facing : Vector2

func get_snapped_position() -> Vector2:
	return Util.floor_v2(position / Game.SNAP)

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

func get_animated_position() -> Vector2:
	return $animated_character_sprite_2d.global_position + $animated_character_sprite_2d.offset

func make_input_vector_4way(iv : Vector2) -> Vector2:
	return Vector2(
		iv.x,
		iv.y * (iv.x == 0) as int
	)

func move_animated(dir : Vector2) -> void:
	move(dir)
	$animated_character_sprite_2d.play_direction(dir, move_cooldown_length)

func _process(delta):
	if Input.is_action_pressed("run"):
		set_move_speed(run_speed)
	else:
		set_move_speed(walk_speed)
	
	var _movement_vector = make_input_vector_4way(get_input_vector())
	
	if is_movable():
		if !Util.compare_v2(_movement_vector, 0):
			if !check_solid_relative(_movement_vector):
				move_animated(_movement_vector)
			else:
				$animated_character_sprite_2d.look_in_direction(_movement_vector)
			facing = _movement_vector
	
	if Input.is_action_just_pressed("interact") && is_movable():
		$interactable_detector_2d.interact_with_facing(position, facing)

func _on_MoveCooldownTimer_timeout():
	._on_MoveCooldownTimer_timeout()
	if Util.compare_v2(get_input_vector(), 0):
		$animated_character_sprite_2d.idle()

func _on_animated_character_sprite_2d_move_animation_finished():
	emit_signal("move_finished", position)
