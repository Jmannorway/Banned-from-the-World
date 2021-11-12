extends TileMap

class_name Maze

export var size : Vector2 = Vector2(15, 10)
export var font : Font = Control.new().get_font("font")
export var maze_position : Vector2
var generating := true
var history : Array

signal done_generating(maze)

enum DIRECTION {
	UP,
	RIGHT,
	DOWN,
	LEFT,
	__MAX,
	NONE
}

const vdir = [
	Vector2(0, -1),
	Vector2(1, 0),
	Vector2(0, 1),
	Vector2(-1, 0),
	Vector2.ZERO
]

func flip_direction(dir : int) -> int:
	return (dir + 2) % DIRECTION.__MAX

func cell_get_wall(cell : int, dir : int) -> int:
	return ((~(cell >> dir)) & 1)

func cell_destroy_wall(cell : int, dir : int) -> int:
	return cell | (1 << dir)

func generate_grid() -> Array:
	var _grid_size = Vector2(size.x * 2 + 1, size.y * 2 + 1)
	var _grid = Util.make_array_2d(_grid_size)
	
	# generate borders
	for x in _grid_size.x:
		_grid[x][0] = 1
		_grid[x][_grid_size.y - 1] = 1
	for y in _grid_size.y:
		_grid[0][y] = 1
		_grid[_grid_size.x - 1][y] = 1
	
	var _cell
	var _pos
	var _check_dir
	
	for x in range(size.x):
		for y in range(size.y):
			_cell = get_cell(x, y)
			_pos = Vector2(1 + x * 2, 1 + y * 2)
			Util.array_2d_set(
				_grid,
				_pos + vdir[DIRECTION.RIGHT],
				cell_get_wall(get_cell(x,y), DIRECTION.RIGHT))
			Util.array_2d_set(
				_grid,
				_pos + vdir[DIRECTION.DOWN],
				cell_get_wall(get_cell(x,y), DIRECTION.DOWN))
			Util.array_2d_set(
				_grid,
				_pos + vdir[DIRECTION.RIGHT] + vdir[DIRECTION.DOWN],
				1)
			
			
	return _grid

# Checks for walls in a cell. If it doesn't lead to an undefined tile it gets pushed to the passed vector
func get_destructible_walls(pos : Vector2, arr_ref : Array) -> void:
	arr_ref.clear()
	var _cell = get_cellv(pos)
	var _checked_cell
	for i in range(DIRECTION.__MAX):
		_checked_cell = get_cellv(pos + vdir[i])
		if _checked_cell != INVALID_CELL && not cell_is_visited(_checked_cell) && cell_get_wall(_cell, i):
			arr_ref.push_back(i)

func cell_is_visited(cell : int):
	var _visited : int = 0
	for i in DIRECTION.__MAX:
		_visited |= ((not cell_get_wall(cell, i)) as int)
	return _visited

func set_all_cells(val : int = 0):
	randomize()
	for x in range(size.x):
		for y in range(size.y):
			set_cell(x, y, val)

func get_random_tile_position() -> Vector2:
	return Vector2(randi() % size.x as int, randi() % size.y as int)

func _ready() -> void:
	set_all_cells()
	maze_position = get_random_tile_position()
	history.push_back(maze_position)

func _process(delta) -> void:
	if generating:
		var _cell = get_cellv(maze_position)
		var _destructible_walls : Array
		get_destructible_walls(maze_position, _destructible_walls)
		
		if _destructible_walls.size() > 0:
			var _option = _destructible_walls[randi() % _destructible_walls.size()]
			set_cellv(maze_position, cell_destroy_wall(_cell, _option))
			maze_position += vdir[_option]
			set_cellv(maze_position, cell_destroy_wall(get_cellv(maze_position), flip_direction(_option)))
			history.push_back(maze_position)
		else:
			var _backtracked = false
			
			for i in range(history.size() - 1, -1, -1):
				get_destructible_walls(history[i], _destructible_walls)
				if _destructible_walls.size() > 0:
					maze_position = history[i]
					history.resize(i + 1)
					_backtracked = true
					break
			
			if not _backtracked:
				generating = false
				emit_signal("done_generating", self)
			pass
	
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Objects/Maze/GeneratedMaze.tscn")
