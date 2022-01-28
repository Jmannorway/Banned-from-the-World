extends Sprite

export var index := 0
export var location_name : String

func _enter_tree():
	var map_manager : MapManager2D = Util.get_first_node_in_group(get_tree(), "map_manager")
	visible = false
	
	if map_manager.player_start_index == index:
		var _player = Player2DUtil.instance_player_2d()
		_player.position = position
		# TODO: Add playe to world not this node's parent (who knows where it might be in the scene tree)
		get_parent().call_deferred("add_child", _player)
		map_manager.reset_player_start_index()
