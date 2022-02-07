extends Node

var object : Object
var alpha_path : String
var fade_duration := 1.0
var visible := false

func _ready():
	set_faded_object($MeshInstance.get_active_material(0), "albedo_color")

func _process(delta):
	if Input.is_action_just_pressed("focus"):
		toggle_fade()

func set_faded_object(new_object : Object, new_color_path : String):
	if new_object && !new_color_path.empty():
		object = new_object
		alpha_path = new_color_path + ":a"
		visible = false
		
		var _col = object.get(new_color_path)
		object.set(new_color_path, Color(_col.r, _col.g, _col.b, 0.0))
	else:
		print("X: Object or alpha path not valid")

func toggle_fade():
	var _a = 0.0 if visible else 1.0
	visible = !visible
	$visibility_tween.stop_all()
	$visibility_tween.interpolate_property(object, alpha_path, null, _a, fade_duration)
	$visibility_tween.start()
