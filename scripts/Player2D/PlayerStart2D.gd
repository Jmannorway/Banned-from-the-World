extends Sprite

export var index := 0
export(String) var room_name

func _ready():
	visible = false
	
	if MapManager.player_start_index == index:
		var _player
		if PlayerAccess.player_2d_exists(get_tree()):
			_player = PlayerAccess.get_player_2d(get_tree())
		else:
			# TODO: Add the player node somewhere meaningful
			_player = PlayerAccess.instance_player_2d()
			get_viewport().call_deferred("add_child", _player)
		
		_player.position = position
		MapManager.reset_player_start_index()
		
		if !room_name.empty():
			MapManager.get_room_manager().focus_room(room_name)
