extends Character2DBase

class_name Character2D

onready var character_sprite = $animated_character_sprite_2d
var frozen : Dictionary

# INTERNAL FUNCTIONS

func _ready():
# warning-ignore:return_value_discarded
	Util.connect_safe(self, "changed_facing_direction", character_sprite, "set_sprite_direction")

# Override the base move to include a footstep sound and animation
func _move(steps : Vector2, direction : Vector2) -> void:
	._move(steps, direction)
	var _new_position = position / Game.SNAP
	WorldGrid.sound_grid.play_cell_sound(_new_position.x, _new_position.y)
	character_sprite.play_direction(steps, direction, get_move_duration())

# Override _post_process_move() to call idle on the newly added sprite node when not moving
func _post_process_move() -> void:
	if !is_moving():
		character_sprite.idle()

# UTILITY
# Get the animated position as opposed to the snappy position & global_position directly
func get_animated_position() -> Vector2:
	return character_sprite.global_position + character_sprite.offset

func set_move_offset(val : Vector2):
	move_offset = val
	if is_moving():
		_move(-last_move, facing)
		_move(calculate_move_offset(facing), facing)

# Reverses a current move, returns true if effective
func reverse_move() -> void:
	if is_moving():
		move_position(last_move * -1.0)
		character_sprite.reverse_move()

func set_frozen(identifier : String, val : bool) -> void:
	frozen[identifier] = val

func is_frozen() -> bool:
	var _frozen = 0
	for i in frozen:
		_frozen |= int(i)
	return _frozen
