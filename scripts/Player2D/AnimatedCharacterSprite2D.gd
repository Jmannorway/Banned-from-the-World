extends AnimatedSprite

class_name AnimatedCharacterSprite2D

signal move_animation_finished

func idle():
	stop()
	frame = 1

func get_animation_from_direction(dir : Vector2) -> String:
	var _animation = ""
	
	if dir.x == 1:
		_animation = "right"
	elif dir.x == -1:
		_animation = "left"
	
	if dir.y == 1:
		_animation = "down"
	elif dir.y == -1:
		_animation = "up"
	
	return _animation

func look_in_direction(dir : Vector2) -> void:
	idle()
	animation = get_animation_from_direction(dir)

func play_direction(dir : Vector2, dur : float) -> void:
	var _animation = get_animation_from_direction(dir)
	
	if _animation.empty():
		idle()
	elif _animation != animation || !is_playing():
		play(_animation)
	
	# offset and tween to make it look like the sprite moves
	offset -= Game.SNAP * dir
	$move_animation_tween.interpolate_property(self, "offset", null, Vector2.ZERO, dur)
	$move_animation_tween.start()
