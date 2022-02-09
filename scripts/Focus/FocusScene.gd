extends Node

export(PackedScene) var focus_scene
export(bool) var is_2d = true

func _ready():
	XToFocus.add_focus_scene(focus_scene, is_2d)
