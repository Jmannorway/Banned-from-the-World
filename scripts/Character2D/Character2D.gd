extends Character2DBase

class_name Character2D

onready var sprite := $animated_character_sprite_2d
var frozen := WeightedBool.new()

func set_frozen(key : String, val : bool) -> void:
	frozen.set_weight(key, val)
	$state_machine.set_process(!frozen.is_weighted())

var update_sprite_direction : bool = true setget set_update_sprite_direction
func set_update_sprite_direction(val : bool):
	update_sprite_direction = val
	if update_sprite_direction:
		Util.connect_safe(self, "changed_facing_direction", sprite, "set_sprite_direction")
	else:
		Util.disconnect_safe(self, "changed_facing_direction", sprite, "set_sprite_direction")

func queue_move_state(_direction : Vector2, _priority : int = 0) -> bool:
	print($state_machine.get_current_state().name)
	if queue_move(_direction, _priority) && $state_machine.get_current_state().name != "move":
		$state_machine.push_by_name("move")
		return true
	return false

# INTERNAL FUNCTIONS
func _ready():
	$state_machine.init(self)
	set_update_sprite_direction(update_sprite_direction)

# Override the base move to include a footstep sound and animation
func _move(steps : Vector2, direction : Vector2) -> void:
	._move(steps, direction)
	var _new_position = position / Game.SNAP
	WorldGrid.get_sound_grid(layer).play_cell_sound(_new_position.x, _new_position.y)
	if update_sprite_direction:
		sprite.play_direction(steps, direction, get_move_duration())
	else:
		sprite.move_direction(steps, get_move_duration())
		sprite.play()

func _post_process_move() -> void:
	if !is_moving():
		sprite.idle()
	update()

# UTILITY
# Get the animated position as opposed to the snappy position & global_position directly
func get_animated_position() -> Vector2:
	return sprite.global_position + sprite.offset

func set_move_offset(val : Vector2):
	move_offset = val
	if is_moving():
		_move(-last_move, facing)
		_move(calculate_move_offset(facing), facing)

# Reverses a current move, returns true if effective
func reverse_move() -> void:
	if is_moving():
		move_position(last_move * -1.0)
		sprite.reverse_move()
