extends Node

const SNAP := 24
const DEBUG := true
const RESOLUTION_2D := Vector2(480, 360)
const RESOLUTION_3D := RESOLUTION_2D * 2

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func create_player() -> Player2D:
	var _player = PlayerUtil.instance_player_2d()
	get_viewport().call_deferred("add_child", _player)
	return _player
