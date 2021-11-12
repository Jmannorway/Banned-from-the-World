class_name Util

static func snap(v : Vector2, grid : Vector2, off : Vector2 = Vector2.ZERO) -> Vector2:
	return Vector2(
		floor(v.x / grid.x) * grid.x + off.x,
		floor(v.y / grid.y) * grid.y + off.y)

static func v3tov2(v : Vector3) -> Vector2:
	return Vector2(v.x, v.y)

static func v2tov3(v : Vector2) -> Vector3:
	return Vector3(v.x, v.y, 0)

static func make_array_2d(size : Vector2, value = 0) -> Array:
	var _arr = []
	_arr.resize(size.x)
	for x in range(size.x):
		_arr[x] = []
		_arr[x].resize(size.y)
		for y in range(size.y):
			_arr[x][y] = value
	return _arr

static func array_2d_set(arr2d : Array, pos : Vector2, value = 0) -> void:
	arr2d[pos.x][pos.y] = value

#static func array_as_string(arr : Array) -> String:
	
