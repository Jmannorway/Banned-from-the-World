extends AnimatedSprite

onready var origin : Vector2 = position
export var slide_length = 30
export var slide_duration = 1

func _on_piano_minigame_manager_pattern_ended():
	frame = randi() % frames.get_frame_count("default")
	position.y = origin.y - slide_length
	$Tween.interpolate_property(
		self,
		"position:y",
		origin.y - slide_length / 2,
		origin.y + slide_length / 2,
		slide_duration)
	$Tween.interpolate_property(
		self,
		"modulate:a",
		0.0,
		1.0,
		slide_duration * 0.25)
	$Tween.interpolate_property(
		self,
		"modulate:a",
		1.0,
		0.0,
		slide_duration * 0.25,
		0,
		2,
		slide_duration * 0.75)
	$Tween.start()
