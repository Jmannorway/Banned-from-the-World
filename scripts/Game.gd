extends Node

const SNAP := 24
const DEBUG := true

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func create_player() -> Player2D:
	var _player = Player2DUtil.instance_player_2d()
	get_viewport().call_deferred("add_child", _player)
	return _player
