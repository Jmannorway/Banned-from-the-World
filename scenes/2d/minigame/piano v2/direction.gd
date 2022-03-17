extends Sprite

export(float, 0.1, 1.5) var rotation_duration = 0.5
var direction : int

func randomize_direction():
	direction += randi() % (Game.DIR4.MAX - 1) + 1
	$rotation_tween.interpolate_property(
		self, "rotation_degrees", null, 90.0 * direction, rotation_duration, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	$rotation_tween.start()
