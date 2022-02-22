extends Sprite

export var index := 0
export(String) var room_name

func _ready():
	visible = false
	
	if MapManager.player_start_index == index:
		var _player = PlayerAccess.get_player_2d(get_tree())
		if !_player:
			_player = PlayerAccess.spawn_player_2d()
			print("spawned")
		else:
			print("not spawned")
		
		_player.position = Util.snap_v2(position, Game.SNAP) + Vector2.ONE * Game.SNAP / 2
		MapManager.reset_player_start_index()
		
		if !room_name.empty():
			MapManager.get_room_manager().focus_room(room_name)
