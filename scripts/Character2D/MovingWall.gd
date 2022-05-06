extends Character2DBase

# Currently it is not possible to move entities without pushing them faster
# than the pushing wall
const ADDED_PUSH_SPEED := 0.1
var direction = Vector2.DOWN

func _init():
	z_as_relative = false
	z_index = 1
	solid = true

func _ready():
	Util.connect_safe(move_cooldown_timer, "timeout", self, "move")
	yield(get_tree(), "idle_frame")
	move()

func move() -> void:
	var _interactable : Interactable2D = $interactable_detector_2d.get_facing_interactable(self, direction)
	# if player is moving to the tile that this wall is moving to then force the player to move backwards
	# if the player is currently on the tile then push it
	if _interactable:
		print("found interactable")
		var _character : Character2D = _interactable.get_parent()
		if _character.is_moving():
			_character.reverse_move()
		else:
			if _character.move_speed < move_speed + ADDED_PUSH_SPEED:
				_character.set_move_speed(move_speed + ADDED_PUSH_SPEED)
			_character.queue_move_state(direction, 0)
	queue_move(direction)
