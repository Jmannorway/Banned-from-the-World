extends AnimatedSprite

var current_direction : Vector2
var idle_frame = 1

func walk(direction : Vector2) -> void:
	if !direction.is_equal_approx(current_direction):
		current_direction = direction
		
		if current_direction.y == 0:
			if direction.x > 0:
				play("walk right")
			elif direction.x < 0:
				play("walk left")

		if current_direction.x == 0:
			if direction.y > 0:
				play("walk down")
			elif direction.y < 0:
				play("walk up")
		
		if direction.x == 0 && direction.y == 0:
			stop()
			frame = idle_frame
