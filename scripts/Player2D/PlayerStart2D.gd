extends Sprite

export var index := 0

func _enter_tree():
	var map_manager : MapManager2D = Util.get_first_node_in_group(get_tree(), "map_manager")
	visible = false
	
	if map_manager.player_start_index == index:
		var _player
		if Player2DUtil.player_exists(get_tree()):
			_player = Player2DUtil.get_player(get_tree())
		else:
			_player = Game.create_player()
		
		_player.position = position
		map_manager.reset_player_start_index()
