extends Character2D

onready var interactable_detector = $interactable_detector_2d
var direction = Vector2.DOWN

func _process(_delta):
	if !is_moving():
		var _facing_interactable = interactable_detector.get_facing_interactable(self, Vector2.DOWN)
		var _player = null
		if _facing_interactable:
			_player = _facing_interactable.owner
			if _player:
				if !_player.reverse_move():
					_player.queue_move(direction, 0)
					print("pushed the player")
				else:
					print("reverse the player")
			else:
				print("player was not owner")
		else:
			print("no interactable")
		
		queue_move(Vector2.DOWN, 10)
