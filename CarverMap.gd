extends TileMap

class_name CarverMap

var size := Vector2(30, 20)
var map := Util.make_array_2d(size, 0)
var carver := Carver.new(Vector2(5, 5), size)

func _process(delta):
	
	carver.step()
	
	Util.array_2d_set(map, carver.position, INVALID_CELL)
	
	for x in size.x:
		for y in size.y:
			set_cell(x, y, map[x][y])
