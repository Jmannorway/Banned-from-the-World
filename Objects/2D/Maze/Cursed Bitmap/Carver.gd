extends Object

class_name Carver

var position : Vector2
var direction : float setget set_direction
var choice_weights : Array
var position_max : Vector2

enum DIRECTION {UP, RIGHT, DOWN, LEFT, __MAX}

func dir2v2(dir : int) -> Vector2:
	match dir:
		DIRECTION.UP:
			return Vector2.UP
		DIRECTION.RIGHT:
			return Vector2.RIGHT
		DIRECTION.DOWN:
			return Vector2.DOWN
		DIRECTION.LEFT:
			return Vector2.LEFT
		_:
			return Vector2.ZERO

func set_direction(new_direction : float):
	direction = new_direction
	var vdir = polar2cartesian(1, deg2rad(direction))
	for i in DIRECTION.__MAX:
		print(dir2v2(i))
		choice_weights[i] = dir2v2(i).dot(vdir) * 0.5 + 0.5

func step() -> void:
	var _choice_max = 0
	for i in DIRECTION.__MAX:
		_choice_max += choice_weights[i]
	
	var _choice = rand_range(0, _choice_max)
	var _weight = 0
	for i in DIRECTION.__MAX:
		_weight += choice_weights[i]
		if _choice < _weight:
			position += dir2v2(i)
	position = Vector2(wrapf(position.x, 0, position_max.x), wrapf(position.y, 0, position_max.y))

func _init(pos : Vector2, pos_max : Vector2) -> void:
	choice_weights.resize(4)
	set_direction(randi() % 360)
	position = pos
	position_max = pos_max
	print(choice_weights)
