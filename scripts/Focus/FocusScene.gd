extends Node

class FocusSceneInformation:
	var focus_scene : PackedScene
	var is_2d : bool = true
	var material : ShaderMaterial
	var params : Dictionary

export(bool) var update_on_ready = true

export(PackedScene) var scene
export(bool) var pass_player_position = false
export(bool) var is_2d = true
export(ShaderMaterial) var material
export(Dictionary) var params

func _ready():
	if update_on_ready:
		update()

func update():
	update_scene()
	update_material()
	update_shader_params()

func update_scene():
	XToFocus.clear_all()
	XToFocus.add_focus_scene(scene, is_2d)
	XToFocus.pass_player_position(pass_player_position)

func update_material():
	XToFocus.set_focus_shader(material)

func update_shader_params():
	XToFocus.set_focus_shader_params(params)
