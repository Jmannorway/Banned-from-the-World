extends Node

const SNAP := 24
const DEBUG := true

func create_player() -> Player2D:
	var _player = Player2DUtil.instance_player_2d()
	get_viewport().call_deferred("add_child", _player)
	return _player
