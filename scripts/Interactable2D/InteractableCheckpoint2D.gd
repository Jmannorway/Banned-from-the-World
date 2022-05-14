extends Interactable2D

export(Statistics.CHECKPOINT) var checkpoint : int
var animation_duration := 1.0

var animation_distance := Vector2(0.0, -4.0)
var active : bool
func set_active(val : bool, instant : bool) -> void:
	var _active := float(val)
	if !instant:
		$activation.interpolate_property($phone, "position", null, animation_distance * _active, animation_duration)
		$activation.interpolate_property($phone/light, "scale", null, Vector2.ONE * _active, animation_duration)
		$activation.interpolate_property($phone/light, "modulate:a", null, _active / 4.0, animation_duration)
		$activation.start()
	else:
		$phone.position = animation_distance * _active
		$phone/light.scale = Vector2.ONE * _active
		$phone/light.modulate.a = _active / 4.0
	
	$phone.animation = "lit" if val else "unlit"
	active = val
	Statistics.metadata.checkpoint = Util.int_set_bit(
			Statistics.metadata.checkpoint,
			checkpoint,
			val)
	Statistics.write_meta_file()

func _ready() -> void:
	set_active(Util.int_get_bit(Statistics.metadata.checkpoint, checkpoint), true)

func interact():
	set_active(!active, false)
