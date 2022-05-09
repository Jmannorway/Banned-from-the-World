extends Node2D

export(Dictionary) var maps
export(NodePath) var cursor
export(PackedScene) var empty

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		var _cursor = get_node(cursor)
		if maps.has(_cursor.direction):
			var _location = maps[_cursor.direction] as Location
			if !_cursor.is_moving():
				MapManager.transition_to_map_by_path(_location.map_path, _location.player_start_index)
				MapManager.transition_manager.connect("transition_middle", self, "queue_free")
				_cursor.active = false
		else:
			print("Quickwarp: maps dictionary does not contain map scene path for direction ", _cursor.direction)
