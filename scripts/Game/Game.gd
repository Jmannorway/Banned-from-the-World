extends Node

const SNAP := 24
const DEBUG := true
const RESOLUTION_2D := Vector2(480, 360)
const RESOLUTION_3D := RESOLUTION_2D * 2

func _ready():
	VisualServer.set_default_clear_color(Color.black)
