extends Character2DBase

class_name Character2D

onready var character_sprite = $animated_character_sprite_2d

# Override the base move to include a footstep sound and animation
func _move(dir : Vector2) -> void:
	._move(dir)
	var _new_position = position / Game.SNAP
	WorldGrid.sound_grid.play_cell_sound(_new_position.x, _new_position.y)
	character_sprite.play_direction(dir, move_cooldown_length)

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

func _on_move_timer_timeout():
	pass # Replace with function body.
