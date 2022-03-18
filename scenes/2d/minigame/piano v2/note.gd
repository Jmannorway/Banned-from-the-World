extends Area2D

var velocity : Vector2
var fade_duration : float = 0.2

func _process(delta):
	position += velocity * delta

func fade():
	$hitbox.set_deferred("disabled", true)
	$fade_tween.interpolate_property(self, "modulate:a", null, 0.0, fade_duration)

func _on_fade_tween_tween_all_completed():
	queue_free()

func _on_note_area_exited(area):
	fade()
