extends Character2DBase

class_name Character2D

onready var character_sprite = $animated_character_sprite_2d

# INTERNAL FUNCTIONS

func _ready():
# warning-ignore:return_value_discarded
	connect("changed_facing_direction", character_sprite, "set_sprite_direction")

# Override the base move to include a footstep sound and animation
func _move(dir : Vector2) -> void:
	._move(dir)
	var _new_position = position / Game.SNAP
	WorldGrid.sound_grid.play_cell_sound(_new_position.x, _new_position.y)
	character_sprite.play_direction(dir, move_cooldown_length)

# Override _post_process_move() to call idle on the newly added sprite node when not moving
func _post_process_move() -> void:
	if !is_moving():
		character_sprite.idle()

# UTILITY
# Get the animated position as opposed to the snappy position & global_position directly
func get_animated_position() -> Vector2:
	return character_sprite.global_position + character_sprite.offset

# Reverses a current move, returns true if effective
func reverse_move() -> bool:
	if is_moving():
		_move(facing * -1)
		var _new_position = position / Game.SNAP
		WorldGrid.sound_grid.play_cell_sound(_new_position.x, _new_position.y)
		character_sprite.reverse_move()
		return true
	else:
		return false
