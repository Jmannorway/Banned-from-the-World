extends Node2D

class_name Character2DBase

# TODO: Add mobility more modes

# Class that holds data and logic for queueing moves
class CharacterMove2D:
	var direction : Vector2
	var priority : int
	const PRIORITY_MIN = -9999999
	const PRIORITY_UNSET = PRIORITY_MIN - 1
	
	func _init() -> void:
		clear()
	func set_move(_direction : Vector2, _priority : int) -> bool:
		if priority < _priority:
			priority = _priority
			direction = Util.clamp_v2(_direction, -Vector2.ONE, Vector2.ONE)
			return true
		else:
			return false
	func is_move_set() -> bool:
		return priority != PRIORITY_UNSET
	func clear() -> void:
		priority = PRIORITY_UNSET
		direction = Vector2.ZERO

enum MOBILITY {
	NORMAL,		# Can't walk through walls or tiles tagged as void
	FLYING,		# Can walk through tiles tagged as void,
	GHOST		# Can walk through any tile
}

export var solid : bool = true
export(MOBILITY) var mobility := MOBILITY.NORMAL
var move_cooldown_length := 0.5
var move_cooldown_timer := Timer.new()
var queued_move := CharacterMove2D.new()
var facing := Vector2.DOWN setget set_facing

func set_facing(dir : Vector2) -> void:
	facing = dir

func set_move_speed(squares_per_second) -> void:
	move_cooldown_length = 1 / squares_per_second

func _enter_tree():
	get_tree().connect("physics_frame", self, "_process_move")
	add_child(move_cooldown_timer)
	move_cooldown_timer.one_shot = true

# Queue a move to be processed
func queue_move(_direction : Vector2, _priority : int) -> void:
	match mobility:
		MOBILITY.NORMAL:
			if !check_solid_relative(_direction):
				queued_move.set_move(_direction, _priority)
		MOBILITY.FLYING:
			queued_move.set_move(_direction, _priority)
		MOBILITY.GHOST:
			queued_move.set_move(_direction, _priority)

func is_moving() -> bool:
	return move_cooldown_timer.time_left != 0.0

# Checks if the relative block in direction is solid
func check_solid_relative(dir : Vector2) -> bool:
	return WorldGrid.solid_grid.get_cell_at_pixel(global_position + dir * Game.SNAP) == 0

# Move the character by a square
func move_position(dir : Vector2) -> void:
	var _move_distance = dir * Game.SNAP
	
	if solid:
		WorldGrid.solid_grid.move_solid(position, _move_distance)
	
	position += _move_distance
	move_cooldown_timer.start(move_cooldown_length)
	set_facing(dir)

# INTERNAL FUNCTIONS
# general move function
func _move(dir : Vector2) -> void:
	move_position(dir)

# Process the queued move
func _process_move() -> void:
	if !is_moving() && queued_move.is_move_set():
		_move(queued_move.direction)
	
	queued_move.clear()
	_post_process_move()

# Override for things you want to have happen after movement has been processed
func _post_process_move() -> void:
	pass
