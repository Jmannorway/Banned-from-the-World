class_name Util

static func make_array_2d(w : int, h : int, val = 0) -> Array:
	var _arr : Array
	_arr.resize(w)
	for x in w:
		_arr[x] = Array()
		_arr[x].resize(h)
		for y in h:
			_arr[x][y] = val
	return _arr

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
	if target.is_a_parent_of(node):
		return
	
	if node.get_parent():
		node.get_parent().remove_child(node)
	
	target.add_child(node)

static func absolute_to_relative_position(absolute_node : Node, relative_node : Node) -> Vector2:
	return absolute_node.global_position - relative_node.global_position

static func snap_v2(v : Vector2, grid) -> Vector2:
	return Vector2(floor(v.x / grid), floor(v.y / grid))

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

static func tern(condition : bool, return_if_true, return_if_false):
	return return_if_true if condition else return_if_false
#	if condition:
#		return return_if_true
#	else:
#		return return_if_false
