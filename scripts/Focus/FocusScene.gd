extends Node

export(bool) var update_on_ready = true

export(PackedScene) var scene
export(bool) var pass_player_position = false
export(bool) var is_2d = true
export(ShaderMaterial) var material
export(Dictionary) var params
export(Vector2) var offset
export(int) var layer = XToFocus.DEFAULT_LAYER_INDEX

func _ready():
	if update_on_ready:
		update()

func update():
	update_scene()
	update_material()
	update_shader_params()

func update_scene():
	if scene:
		XToFocus.reset()
		XToFocus.add_focus_scene(scene, is_2d)
		XToFocus.pass_player_position(pass_player_position)
		XToFocus.set_focus_scene_position(offset);
		XToFocus.set_focus_scene_layer(layer);
	else:
		print("FocusScene: No focus scene")

func update_material():
	XToFocus.set_focus_shader(material)

func update_shader_params():
	XToFocus.set_focus_shader_params(params)
