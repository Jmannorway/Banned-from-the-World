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
	var _player_interactable : Interactable2D = $interactable_detector_2d.get_facing_interactable(self, direction)
	# if player is moving to the tile that this wall is moving to then force the player to move backwards
	# if the player is currently on the tile then push it
	if _player_interactable:
		var _player : Player2D = _player_interactable.get_parent()
		if _player.is_moving():
			_player.reverse_move()
		else:
			if _player.move_speed < move_speed + ADDED_PUSH_SPEED:
				_player.set_move_speed(move_speed + ADDED_PUSH_SPEED)
			_player.queue_move(direction, 0)
	
	queue_move(direction)
