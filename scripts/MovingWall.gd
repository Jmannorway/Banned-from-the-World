extends Character2D

onready var sprite = $animated_character_sprite_2d
onready var interactable_detector = $interactable_detector_2d
var direction = Vector2.DOWN

func _process(_delta):
	if is_movable():
		var _facing_interactable = interactable_detector.get_facing_interactable(global_position, Vector2.DOWN)
		var _player = null
		if _facing_interactable:
			_player = _facing_interactable.owner
			if _player:
				if !_player.reverse_move():
					_player.move_animated(direction)
					print("pushed the player")
				else:
					print("reverse the player")
			else:
				print("player was not owner")
		else:
			print("no interactable")
		
		move(direction)
		sprite.move_direction(direction, move_cooldown_length)
