extends Node2D

# TODO: Spawing in a bigger room does not generate the correct room bounds

var bounds : Rect2
var target : Node2D
var room_view : Rect2
var camera_position : Vector2

export(String) var target_group = PlayerAccess.PLAYER_2D_GROUP_NAME
export(bool) var target_is_character
export(bool) var free
export(bool) var smoothing_enabled
export(float) var smoothing_speed := 5.0
export(bool) var smooth_bounds
export(bool) var current = true

func _get_property_list() -> Array:
	var _props = []
	_props.append(
		{
			name = "Smoothing",
			type = TYPE_NIL,
			hint_string = "smoothing_",
			usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	return _props

func _enter_tree():
	if !Engine.editor_hint && !MapManager.get_room_manager().is_connected("room_focused", self, "_on_RoomManager_RoomFocused"):
		MapManager.get_room_manager().connect("room_focused", self, "_on_RoomManager_RoomFocused")

func _process(delta):
	if !Engine.editor_hint:
		target = Util.get_first_node_in_group(get_tree(), target_group)
		
		if target:
			if target_is_character:
				position = target.get_animated_position()
			else:
				position = target.global_position
		
		if !free && smooth_bounds:
			position = Util.clamp_v2(position, bounds.position, bounds.end)
		
		if smoothing_enabled:
			camera_position += (
				(position - camera_position).normalized() *
				camera_position.distance_to(position) * delta * smoothing_speed)
		else:
			camera_position = position
		
		if !free && !smooth_bounds:
			camera_position = Util.clamp_v2(camera_position, bounds.position, bounds.end)
		
		var _viewport_size = get_viewport_rect().size
		
		if current:
			get_viewport().canvas_transform.origin = -camera_position + _viewport_size / 2.0
		
		room_view.position = get_room_position() - _viewport_size / 2.0
		room_view.size = _viewport_size

func get_room_position() -> Vector2:
	return camera_position - MapManager.get_room_manager().get_current_room_loader().position

func get_room_default_bounds(room_node : RoomLoader2D) -> Rect2:
	var _b : Rect2
	
	_b.position = Util.min_v2(
		room_node.global_position + get_viewport_rect().size / 2.0,
		room_node.get_global_middle())
	_b.end = Util.max_v2(
		room_node.global_position + room_node.size - get_viewport_rect().size / 2.0,
		room_node.get_global_middle())
	
	return _b

func _on_RoomManager_RoomFocused(room_name : String, room_node : RoomLoader2D) -> void:
	if false:
		pass
	else:
		bounds = get_room_default_bounds(room_node)
	
	if free:
		bounds.position = Vector2(-1000000, -1000000)
		bounds.end = Vector2(1000000, 1000000)
