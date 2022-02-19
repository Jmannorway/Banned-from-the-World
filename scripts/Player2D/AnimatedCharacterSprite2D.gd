extends AnimatedSprite

# TODO: Make a system to bind differe or the same animations to
# the cardinal directions

class_name AnimatedCharacterSprite2D

var sprite_direction : Vector2 setget set_sprite_direction
var move_direction : Vector2
export(int) var idle_frame = 1

signal move_animation_finished

func idle():
	stop()
	frame = idle_frame

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

func set_sprite_direction(dir : Vector2):
	animation = get_animation_from_direction(dir)
	sprite_direction = dir

func look_in_direction(dir : Vector2) -> void:
	idle()
	set_sprite_direction(dir)

func play_direction(dir : Vector2, dur : float) -> void:
	var _animation = get_animation_from_direction(dir)
	
	if _animation.empty():
		idle()
	elif _animation != animation || !is_playing():
		set_sprite_direction(dir)
		play(_animation)
	
	move_direction(dir, dur)

func reverse_move() -> void:
	var _duration = $move_animation_tween.get_runtime()
	var _factor = 1.0 - $move_animation_tween.tell() / _duration
	finish_move()
	move_direction(move_direction * -1, _duration, _factor)

func move_direction(dir : Vector2, dur : float, factor : float = 0.0) -> void:
	# offset and tween to make it look like the sprite moves
	offset -= Game.SNAP * dir
	$move_animation_tween.interpolate_property(self, "offset", null, Vector2.ZERO, dur)
	$move_animation_tween.start()
	
	if factor != 0.0:
		$move_animation_tween.seek(dur * factor)
	
	move_direction = dir

func finish_move() -> void:
	$move_animation_tween.stop_all()
	offset = Vector2.ZERO
