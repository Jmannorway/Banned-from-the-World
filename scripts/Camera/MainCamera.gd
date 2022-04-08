tool

extends Camera

var trans := Tween.TRANS_SINE

export(Vector3) var gameplay_translation setget set_gameplay_translation
func set_gameplay_translation(val):
	gameplay_translation = val
	if Engine.editor_hint:
		translation = val

export(Vector3) var gameplay_rotation_degrees setget set_gameplay_rotation_degrees
func set_gameplay_rotation_degrees(val):
	gameplay_rotation_degrees = val
	if Engine.editor_hint:
		rotation_degrees = val

func _ready():
	if !Engine.editor_hint:
		set_zero_position(0.0)

func is_transitioning() -> bool:
	return $position_tween.is_active()

func set_gameplay_position(duration : float):
	if duration == 0.0:
		translation = gameplay_translation
		rotation_degrees = gameplay_rotation_degrees
	else:
		$position_tween.interpolate_property(self, "translation", null, gameplay_translation, duration, trans)
		$position_tween.interpolate_property(self, "rotation_degrees", null, gameplay_rotation_degrees, duration, trans)
		$position_tween.start()

func set_zero_position(duration : float):
	if duration == 0.0:
		translation = Vector3.ZERO
		rotation_degrees = Vector3.ZERO
	else:
		$position_tween.interpolate_property(self, "translation", null, Vector3.ZERO, duration, trans)
		$position_tween.interpolate_property(self, "rotation_degrees", null, Vector3.ZERO, duration, trans)
		$position_tween.start()
