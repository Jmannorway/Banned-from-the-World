extends Area2D

var speed : float
var direction : int
var fade_duration : float = 0.2

func get_velocity() -> Vector2:
	return Game.VDIR4[direction] * speed

func _ready():
	$fade_tween.interpolate_property(self, "modulate:a", null, 0.0, fade_duration)

func _process(delta):
	position += get_velocity() * delta

func fade():
	$fade_tween.start()

func _on_fade_tween_tween_all_completed():
	queue_free()

func _on_note_area_exited(area):
	fade()
