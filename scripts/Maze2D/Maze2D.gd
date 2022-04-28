extends Reference

class_name Maze2D

enum DIRECTION {UP, RIGHT, DOWN, LEFT, _MAX}
const DIRECTIONV = [
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT
]

var data : Array

func size() -> Vector2:
	return Vector2(data.size(), 0 if data.size() == 0 else data[0].size())

func resize(new_size : Vector2) -> void:
	data = Util.make_array_2d(new_size.x, new_size.y)

func has_visited(pos : Vector2) -> bool:
	return data[pos.x][pos.y] != 0

func has_hole(pos : Vector2, dir : int) -> bool:
	return ((data[pos.x][pos.y] >> dir) & 1) == 1

func make_hole(pos : Vector2, dir : int) -> void:
	data[pos.x][pos.y] |= (1 << dir)

func drill_hole(pos : Vector2, dir : int) -> void:
	make_hole(pos, dir)
	make_hole(pos + DIRECTIONV[dir], reverse_direction(dir))

func reverse_direction(dir : int) -> int:
	return (dir + 2) % DIRECTION._MAX

func is_within_bounds(pos : Vector2) -> bool:
	var _size = size()
	return pos.x >= 0 && pos.x < _size.x && pos.y >= 0 && pos.y < _size.y

func is_valid_move(pos : Vector2) -> bool:
	return is_within_bounds(pos) && !has_visited(pos)

func get_valid_moves(pos : Vector2) -> Array:
	var moves : Array
	for i in DIRECTION._MAX:
		if is_valid_move(pos + DIRECTIONV[i]):
			moves.push_back(i)
	return moves

func make_maze_recursive_backtrack(maze_size : Vector2) -> void:
	resize(maze_size)
	
	var _location = Vector2(randi() % (maze_size.x as int), randi() % (maze_size.y as int))
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
