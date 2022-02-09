extends Sprite

export var index := 0
export(String) var room_name

func _ready():
	visible = false
	
	if MapManager.player_start_index == index:
		var _player
		if PlayerUtil.player_2d_exists(get_tree()):
			_player = PlayerUtil.get_player_2d(get_tree())
		else:
			_player = Game.create_player()
		
		_player.position = position
		MapManager.reset_player_start_index()
		
		if !room_name.empty():
			MapManager.get_room_manager().focus_room(room_name)
