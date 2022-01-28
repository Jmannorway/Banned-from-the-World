extends AnimatedSprite

func idle() -> void:
	playing = false
	frame = 1

func play_direction(dir : Vector2, running := false):
	if !playing:
		frame = 1
	
	if dir.x == 1:
		play("right")
	elif dir.x == -1:
		play("left")
	
	if dir.y == 1:
		play("down")
	elif dir.y == -1:
		play("up")
