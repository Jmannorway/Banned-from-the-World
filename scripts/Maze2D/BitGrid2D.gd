extends Reference

class_name BitGrid2D

var data : Array # 2d array

func size() -> Vector2:
	return Vector2(data.size(), data[0].size())

func resize(new_size : Vector2) -> void:
	Util.resize_array_2d(data, new_size)

func copy_area(src : BitGrid2D, src_rect : Rect2, dest_pos : Vector2) -> void:
	for x in src_rect.size.x:
		for y in src_rect.size.y:
			data[dest_pos.x + x][dest_pos.y + y] = src.data[src_rect.position.x + x][src_rect.position.y + y]

# No static typing here to avoid cyclic dependency
func create_from_maze(maze) -> void:
	var _size = maze.size()
	data = Util.make_array_2d(_size.x * 2 + 1, _size.y * 2 + 1)
	
	for x in range(0, _size.x - 1):
		for y in range(0, _size.y - 1):
			var _pos = Vector2(x * 2 + 1, y * 2 + 1)
			data[_pos.x+1][_pos.y+1] = 1
			data[_pos.x+1][_pos.y] = (!maze.has_hole(Vector2(x, y), Maze2D.DIRECTION.RIGHT)) as int
			data[_pos.x][_pos.y+1] = (!maze.has_hole(Vector2(x, y), Maze2D.DIRECTION.DOWN)) as int
	
	for x in _size.x * 2:
		data[x][0] = 1
		data[x][_size.y * 2] = 1
	
	for y in _size.y * 2:
		data[0][y] = 1
		data[_size.x * 2][y] = 1
	
	data[_size.x * 2][_size.y * 2] = 1

func set_area(area : Rect2, val : bool):
	var _val = int(val)
	for x in range(area.position.x, area.position.x + area.size.x):
		for y in range(area.position.y, area.position.y + area.size.y):
			data[x][y] = _val

func autotile_1(tilemap : TileMap, tile_index : int):
	var _size = size()
	for x in _size.x:
		for y in _size.y:
			if data[x][y]:
				tilemap.set_cell(x, y, tile_index)

func autotile_47(tilemap : TileMap, tile_index : int, wrap : bool):
	# gather all available autotile coordinate positions in a dictionary
	# using a each tile's bitmask as a key (only one tile variation is supported)
	var _autotile_coords = Util.tilemap_get_autotile_coord_dictionary(tilemap, tile_index)
	var _size = size()
	
	var xl
	var xr
	var yt
	var yb
	var c
	var t
	var b
	var l
	var r
	var tl
	var tr
	var bl
	var br
	var bm
	
	var _pos_func
	if wrap:
		_pos_func = "_wrap_position"
	else:
		_pos_func = "_clamp_position"
	
	for x in _size.x:
		# currently clamping the check (wrap could be better for looping purposes)
		xl = call(_pos_func, x-1, 0, _size.x)
		xr = call(_pos_func, x+1, 0, _size.x)
		for y in _size.y:
			yt = call(_pos_func, y-1, 0, _size.y)
			yb = call(_pos_func, y+1, 0, _size.y)
			
			# center nulls out all other tiles
			c = data[x][y]
			
			t = data[x][yt] & c
			b = data[x][yb] & c
			l = data[xl][y] & c
			r = data[xr][y] & c
			
			# corners get nulled if sides aren't active
			tl = data[xl][yt] & l & t
			tr = data[xr][yt] & r & t
			bl = data[xl][yb] & l & b
			br = data[xr][yb] & r & b
			
			bm = (
				tl * TileSet.BIND_TOPLEFT |
				t * TileSet.BIND_TOP |
				tr * TileSet.BIND_TOPRIGHT |
				l * TileSet.BIND_LEFT |
				c * TileSet.BIND_CENTER |
				r * TileSet.BIND_RIGHT |
				bl * TileSet.BIND_BOTTOMLEFT |
				b * TileSet.BIND_BOTTOM |
				br * TileSet.BIND_BOTTOMRIGHT)
			
			tilemap.set_cell(x, y, tile_index, false, false, false, _autotile_coords[bm])

# Position functions for internal use
func _wrap_position(val : int, mn : int, mx : int) -> int:
	return wrapi(val, mn, mx)

func _clamp_position(val : int, mn : int, mx : int) -> int:
	return int(clamp(val, mn, mx - 1))
