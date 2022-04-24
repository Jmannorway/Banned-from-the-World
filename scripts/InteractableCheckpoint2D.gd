extends Interactable2D

export(Statistics.CHECKPOINT) var checkpoint : int

var animation_distance := Vector2(0.0, -4.0)
var active : bool setget set_active
func set_active(val : bool) -> void:
	if !$activation.is_active():
		var _active := float(val)
		$activation.interpolate_property($phone, "position", null, animation_distance * _active, 1.0)
		$activation.interpolate_property($phone/light, "scale", null, Vector2.ONE * _active, 1.0)
		$activation.interpolate_property($phone/light, "modulate:a", null, _active / 4.0, 1.0)
		$activation.start()
		$phone.animation = "lit" if val else "unlit"
		active = val
		Statistics.metadata.checkpoint = Util.int_set_bit(
				Statistics.metadata.checkpoint,
				checkpoint,
				val)

func step():
	pass

func interact():
	set_active(!active)
