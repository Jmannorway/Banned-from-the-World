extends Object

class_name RecursiveBacktrack

enum DIRECTION {UP, RIGHT, DOWN, LEFT, _MAX}
const DIRECTIONV = [
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT
]

var size := Vector2(8, 8)
var data : Array

func make_grid() -> Array:
	var _grid = Util.make_array_2d(size.x * 2 + 1, size.y * 2 + 1)
	
	for x in range(0, size.x - 1):
		for y in range(0, size.y - 1):
			var _pos = Vector2(x * 2 + 1, y * 2 + 1)
			_grid[_pos.x+1][_pos.y+1] = 1
			_grid[_pos.x+1][_pos.y] = (!has_hole(Vector2(x, y), DIRECTION.RIGHT)) as int
			_grid[_pos.x][_pos.y+1] = (!has_hole(Vector2(x, y), DIRECTION.DOWN)) as int
	
	for x in size.x * 2:
		_grid[x][0] = 1
		_grid[x][size.y * 2] = 1
	
	for y in size.y * 2:
		_grid[0][y] = 1
		_grid[size.x * 2][y] = 1
	
	_grid[size.x * 2][size.y * 2] = 1
	
	return _grid

func has_visited(pos : Vector2) -> bool:
	return data[pos.x][pos.y] != 0

func has_hole(pos : Vector2, dir : int) -> bool:
	return ((data[pos.x][pos.y] >> dir) & 1) == 1

func make_hole(pos : Vector2, dir : int) -> void:
	data[pos.x][pos.y] |= (1 << dir)

func reverse_direction(dir : int) -> int:
	return (dir + 2) % DIRECTION._MAX

func is_within_bounds(pos : Vector2) -> bool:
	return pos.x >= 0 && pos.x < size.x && pos.y >= 0 && pos.y < size.y

func is_valid_move(pos : Vector2) -> bool:
	return is_within_bounds(pos) && !has_visited(pos)

func get_valid_moves(pos : Vector2) -> Array:
	var moves : Array
	for i in DIRECTION._MAX:
		if is_valid_move(pos + DIRECTIONV[i]):
			moves.push_back(i)
	return moves

func make_maze(maze_size : Vector2) -> void:
	size = maze_size
	data = Util.make_array_2d(size.x, size.y)
	
	var _location = Vector2(randi() % (size.x as int), randi() % (size.y as int))
	var _history : Array
	_history.push_back(_location)
	
	while _history.size():
		var _moves = get_valid_moves(_location)
		
		if (_moves.size() == 0):
			_location = _history[_history.size() - 1]
			_history.remove(_history.size() - 1)
		else:
			var _direction = _moves[randi() % _moves.size()]
			make_hole(_location, _direction)
			_location += DIRECTIONV[_direction]
			make_hole(_location, reverse_direction(_direction))
			_history.push_back(_location)
