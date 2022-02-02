extends Camera2D

export var target_group := Player2DUtil.PLAYER_GROUP_NAME
export var target_is_character := true
var target : Node2D
var area : Rect2

func _enter_tree():
	var room_manager = MapManager.get_room_manager()
	room_manager.connect("room_focused", self, "_on_RoomManager2D_RoomFocused")

func _process(delta):
	target = Util.get_first_node_in_group(get_tree(), "player")
	var _target_position = offset
	
	if is_instance_valid(target):
		if target_is_character:
			_target_position = target.get_animated_position()
		else:
			_target_position = target.position
	
	offset = Util.clamp_v2(_target_position, area.position, area.end)
#	print(_target_position, offset)

func _on_RoomManager2D_RoomFocused(room_name, room_node):
	if false:
		pass
	else:
		var r = room_node as RoomLoader2D
		var _half_view = get_viewport_rect().size / 2.0
		
		area.position = Util.min_v2(
			r.global_position + _half_view,
			r.get_global_middle())
		area.end = Util.max_v2(
			r.global_position + r.size - _half_view,
			r.get_global_middle())
		
		print(_half_view)
