extends AnimatedSprite

var current_direction : Vector2

func move(ani : String) -> void:
	play(ani)
	frame = 0

func idle() -> void:
	stop()
	frame = 1
	current_direction = Vector2.ZERO

func walk(direction : Vector2) -> void:
	if direction.x != current_direction.x || direction.y != current_direction.y:
		if direction.x < 0:
			move("walk left")
		elif direction.x > 0:
			move("walk right")
		
		if direction.y < 0:
			move("walk up")
		elif direction.y > 0:
			move("walk down")
		
		current_direction = direction
