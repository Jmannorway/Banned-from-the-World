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
