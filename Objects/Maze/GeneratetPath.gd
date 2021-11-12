extends TileMap

export var size : Vector2 = Vector2(15, 10)
export var font : Font = Control.new().get_font("font")
export var maze_position : Vector2
var history : Array

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

# Checks for walls in a cell. If it doesn't lead to an undefined tile it gets pushed to the passed vector
func get_destructible_walls(pos : Vector2, arr_ref : Array) -> void:
	arr_ref.clear()
	var _cell = get_cellv(pos)
	var _checked_cell
	for i in range(DIRECTION.__MAX):
		_checked_cell = get_cellv(pos + vdir[i])
		if _checked_cell != INVALID_CELL && not cell_is_visited(_checked_cell) && cell_get_wall(_cell, i):
			arr_ref.push_back(i)

# search 
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
	var _cell = get_cellv(maze_position)
	var _destructible_walls : Array
	get_destructible_walls(maze_position, _destructible_walls)
	
	if _destructible_walls.size() > 0:
		var _option = _destructible_walls[randi() % _destructible_walls.size()]
		set_cellv(maze_position, cell_destroy_wall(_cell, _option))
		maze_position += vdir[_option]
		set_cellv(maze_position, cell_destroy_wall(get_cellv(maze_position), flip_direction(_option)))
	
	
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Objects/Maze/GeneratedMaze.tscn")
#	if Input.is_action_just_pressed("mouse_left"):
#		var _tilemap_position = world_to_map(get_local_mouse_position())
#		if get_cellv(_tilemap_position) == INVALID_CELL:
#			set_cellv(_tilemap_position, 0)
#		else:
#			set_cellv(_tilemap_position, INVALID_CELL)
	pass
#	var _mouse_cell = get_cellv(world_to_map(get_local_mouse_position()))
#	var _walls = [
#		cell_get_wall(_mouse_cell, DIRECTION.UP),
#		cell_get_wall(_mouse_cell, DIRECTION.RIGHT),
#		cell_get_wall(_mouse_cell, DIRECTION.DOWN),
#		cell_get_wall(_mouse_cell, DIRECTION.LEFT)
#	]
#	print("Walls at mouse: ", _walls)
