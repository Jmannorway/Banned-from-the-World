extends AnimatedSprite

func _on_InputArrow_animation_finished():
	stop()
	set_deferred("frame", 0)
