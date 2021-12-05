extends Sprite

export var index := 0
export var location_name : String
const INVALID_PLAYER_START_INDEX = -1

func _enter_tree():
	if Game.player_start_index == index:
		var _player = Game.instance_player_2d()
		if _player:
			_player.position = position
			get_parent().call_deferred("add_child", _player)
		visible = false
		Game.player_start_index = INVALID_PLAYER_START_INDEX
