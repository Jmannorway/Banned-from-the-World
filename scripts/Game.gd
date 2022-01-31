extends Node

const SNAP := 24
const DEBUG := true

func create_player() -> Player2D:
	var _player = Player2DUtil.instance_player_2d()
	add_child(_player)
	return _player
