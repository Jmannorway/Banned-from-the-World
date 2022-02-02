extends Sprite

export var index := 0
export(String) var room_name

func _ready():
	visible = false
	
	if MapManager.player_start_index == index:
		var _player
		if Player2DUtil.player_exists(get_tree()):
			_player = Player2DUtil.get_player(get_tree())
		else:
			_player = Game.create_player()
		
		_player.position = position
		MapManager.reset_player_start_index()
		
		if !room_name.empty():
			MapManager.get_room_manager().focus_room(room_name)
