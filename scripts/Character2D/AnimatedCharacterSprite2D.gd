extends AnimatedSprite

# TODO: Make a system to bind differe or the same animations to
# the cardinal directions

class_name AnimatedCharacterSprite2D

var sprite_direction : Vector2 setget set_sprite_direction
var move_direction : Vector2
export(int) var idle_frame = 1

const ANI_DIR := {
	"right" : Vector2.RIGHT,
	"left" : Vector2.LEFT,
	"up" : Vector2.UP,
	"down" : Vector2.DOWN}

# warning-ignore:unused_signal
signal move_animation_finished

func _ready():
	if ANI_DIR.has(animation):
		sprite_direction = ANI_DIR[animation]
		move_direction = ANI_DIR[animation]

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

func rotate_clockwise():
	var _dir = sprite_direction
	_dir = _dir.rotated(deg2rad(90))
	_dir.x = round(_dir.x)
	_dir.y = round(_dir.y)
	set_sprite_direction(_dir)

func set_sprite_direction(dir : Vector2):
	var _f = frame
	animation = get_animation_from_direction(dir)
	frame = _f
	sprite_direction = dir

func look_in_direction(dir : Vector2) -> void:
	idle()
	set_sprite_direction(dir)

func play_direction(steps : Vector2, direction : Vector2, duration : float) -> void:
	var _animation = get_animation_from_direction(direction)
	
	if _animation.empty():
		idle()
	elif _animation != animation || !is_playing():
		play(_animation)
	
	move_direction(steps, duration)

func reverse_move() -> void:
	var _duration = $move_animation_tween.get_runtime()
	var _factor = 1.0 - $move_animation_tween.tell() / _duration
	finish_move()
	move_direction(move_direction * -1, _duration, _factor)

# warning-ignore:function_conflicts_variable
func move_direction(dir : Vector2, dur : float, factor : float = 0.0) -> void:
	# offset and tween to make it look like the sprite moves
	offset -= Game.SNAP * dir
	$move_animation_tween.interpolate_property(self, "offset", null, Vector2.ZERO, dur)
	$move_animation_tween.start()
	
	if factor != 0.0:
		$move_animation_tween.seek(dur * factor)
	
	move_direction = dir

func finish_move() -> void:
	$move_animation_tween.remove_all()
	offset = Vector2.ZERO
