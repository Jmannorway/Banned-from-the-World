extends Sprite

export(float, 0.1, 1.5) var rotation_duration = 0.5
var direction : int setget set_direction
export(AudioStream) var rotation_finish_sound
export(AudioStream) var rotation_sound
func set_direction(val : int):
	previous_direction = direction
	if val != direction:
		direction = val % Game.DIR4.MAX
		$rotation_tween.interpolate_property(
			self, "rotation_degrees", null, 90.0 * direction, rotation_duration, Tween.TRANS_BOUNCE, Tween.EASE_IN)
		$rotation_tween.start()
		MusicManager.play_sound(rotation_sound)

var previous_direction : int

func set_random_direction():
	set_direction(direction + (randi() % (Game.DIR4.MAX - 1) + 1) % Game.DIR4.MAX)

func _on_rotation_tween_tween_all_completed():
	MusicManager.play_sound(rotation_finish_sound)
	$diffuse_sprite.diffuse()
