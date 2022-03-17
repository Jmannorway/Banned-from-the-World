class_name Util

enum DIRECTION {UP, LEFT, RIGHT, DOWN}

# TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP

static func goto_world(tree : SceneTree, world : int) -> void:
	Game.set_world(world)
	
	if world == Game.WORLD.OUTER:
		Statistics.metadata["inner_world_travel_count"] += 1
		# Clear 2d world
		MapManager.clear_map()
		# Load default 3d world
		tree.change_scene("res://scenes/3d/real_world.tscn")
	else:
		# Clear 3d world
		tree.change_scene("res://scenes/empty.tscn")
		# Load 2d scene
		if Statistics.metadata["checkpoint"] == 0:
			MapManager.warp_to_map_by_path("res://scenes/2d/maps/phase_2_map.tscn")
		else:
			print("warps to quickwarp screen")

# TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP

static func make_array_2d(w : int, h : int, val = 0) -> Array:
	var _arr : Array
	_arr.resize(w)
	for x in w:
		_arr[x] = Array()
		_arr[x].resize(h)
		for y in h:
			_arr[x][y] = val
	return _arr

# Assumes a rectangular array
# Array must be passed by reference
static func resize_array_2d(array2d : Array, new_size : Vector2) -> void:
	
	var _old_size = array2d.size()
	array2d.resize(new_size.x)
	
	if _old_size < new_size.x:
		for x in range(_old_size, new_size.x):
			array2d[x] = Array()
	
	for x in new_size.x:
		array2d[x].resize(new_size.y)

static func tilemap_get_autotile_coord_dictionary(
	tilemap : TileMap,
	tile_index : int = 0,
	tileset_area := Rect2(Vector2.ZERO, Vector2(12, 4))) -> Dictionary:
	
	var autotile_coords : Dictionary
	for x in tileset_area.size.x:
		for y in tileset_area.size.y:
			autotile_coords[tilemap.tile_set.autotile_get_bitmask(tile_index, Vector2(x, y))] = Vector2(x, y);
	return autotile_coords

static func randi_range(from : int, to : int) -> int:
	return (randi() % (int(max(to - from, 1)))) + from

static func connect_safe(object : Object, signal_name : String, target : Object, method_name : String, binds : Array = [], flags : int = 0):
	if !object.is_connected(signal_name, target, method_name):
		object.connect(signal_name, target, method_name, binds, flags)

static func disconnect_safe(object : Object, signal_name : String, target : Object, method_name : String) -> void:
	if object.is_connected(signal_name, target, method_name):
		object.disconnect(signal_name, target, method_name)

# checks if the node is queued for deletion by also checking all of its parents
static func deep_is_queued_for_deletion(node : Node):
	if node.is_queued_for_deletion():
		return true
	else:
		var _parent = node.get_parent()
		var _queued = false
		while (_parent):
			if _parent.is_queued_for_deletion():
				return true
			else:
				_parent = _parent.get_parent()
	
	return false

static func get_filename_from_path(path : String) -> String:
	var _last_slash = path.find_last("/")
	var _dot = path.find_last(".")
	if _last_slash != -1 && _dot != -1:
		return path.substr(_last_slash + 1, _dot - _last_slash - 1)
	else:
		return ""

static func get_first_node_in_group(tree : SceneTree, group_name : String):
	var group = tree.get_nodes_in_group(group_name)
	if group.size() > 0:
		return group[0]
	else:
		return null

static func object_set_alpha(object : Object, color_path : String, val : float):
	var _col = object.get(color_path)
	object.set(color_path, Color(_col.r, _col.g, _col.b, val))

static func reparent_to(node : Node, target : Node):
	if target == node.get_parent():
		return
	
	if node.get_parent():
		node.get_parent().remove_child(node)
	
	target.add_child(node)

static func reparent_to_deferred(node : Node, target : Node):
	if target == node.get_parent():
		return
	
	if node.get_parent():
		node.get_parent().call_deferred("remove_child", node)
	
	target.call_deferred("add_child", node)

static func absolute_to_relative_position(absolute_node : Node, relative_node : Node) -> Vector2:
	return absolute_node.global_position - relative_node.global_position

static func snap_v2(v : Vector2, grid) -> Vector2:
	return Vector2(floor(v.x / grid), floor(v.y / grid)) * grid

static func floor_v2(v : Vector2) -> Vector2:
	return Vector2(floor(v.x), floor(v.y))

static func clamp_v2(v : Vector2, mn : Vector2, mx : Vector2) -> Vector2:
	return Vector2(clamp(v.x, mn.x, mx.x), clamp(v.y, mn.y, mx.y))

static func compare_v2(v : Vector2, val : float) -> bool:
	return v.x == val && v.y == val

static func min_v2(a : Vector2, b : Vector2) -> Vector2:
	return Vector2(min(a.x, b.x), min(a.y, b.y))

static func max_v2(a : Vector2, b : Vector2) -> Vector2:
	return Vector2(max(a.x, b.x), max(a.y, b.y))

# fuck you
static func tern(condition : bool, return_if_true, return_if_false):
	return return_if_true if condition else return_if_false
