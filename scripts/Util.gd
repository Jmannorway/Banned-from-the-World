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

static func absolute_to_relative_position(absolute_node : Node, relative_node : Node) -> Vector2:
	return absolute_node.global_position - relative_node.global_position

static func snap_v2(v : Vector2, grid) -> Vector2:
	return Vector2(floor(v.x / grid), floor(v.y / grid))

static func floor_v2(v : Vector2) -> Vector2:
	return Vector2(floor(v.x), floor(v.y))

static func compare_v2(v : Vector2, val : float) -> bool:
	return v.x == val && v.y == val

static func tern(condition : bool, return_if_true, return_if_false):
	if condition:
		return return_if_true
	else:
		return return_if_false
