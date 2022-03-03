extends Node2D

class_name Character2DBase

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

enum DIRECTION {RIGHT, UP, LEFT, DOWN, _MAX}

const VDIRECTION = [
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.LEFT,
	Vector2.DOWN]

enum MOBILITY {
	NORMAL,		# Can't walk through walls or tiles tagged as void
	FLYING,		# Can walk through tiles tagged as void,
	GHOST		# Can walk through any tile
}

signal changed_facing_direction(facing)
signal move_finished

export var solid := true
export(MOBILITY) var mobility = MOBILITY.NORMAL # TODO: Implement
export(float, 0.1, 16.0) var move_speed = 2.0 setget set_move_speed
var move_cooldown_timer := Timer.new()
var queued_move := CharacterMove2D.new()
var facing := Vector2.DOWN setget set_facing
var last_move : Vector2

# INTERNAL FUNCTIONS
func _enter_tree():
	snap_to_grid()
# warning-ignore:return_value_discarded
	Util.connect_safe(get_tree(), "physics_frame", self, "_process_move")
	add_child(move_cooldown_timer)
	move_cooldown_timer.one_shot = true
	
	if solid:
		WorldGrid.solid_grid.set_solid(global_position, true)

# general move function
func _move(dir : Vector2) -> void:
	move_position(dir)
	set_facing(dir)

# Process the queued move
func _process_move() -> void:
	if !is_moving() && queued_move.is_move_set():
		_move(queued_move.direction)
	
	queued_move.clear()
	_post_process_move()

# Override for post movement behavior
func _post_process_move() -> void:
	update_solidity()

# Callbacks
func update_solidity() -> void:
	if solid:
		WorldGrid.solid_grid.set_solid_at_pixel(global_position, true)

# SETTERS & GETTERS
func set_move_speed(val : float) -> void:
	if val > 0.0:
		move_speed = val

func get_move_duration() -> float:
	return 1 / move_speed

static func get_move_duration_at_speed(speed : float) -> float:
	return 1 / speed

func set_facing(dir : Vector2) -> void:
	if facing != dir:
		facing = dir
		emit_signal("changed_facing_direction", facing)

func set_integer_position(ipos : Vector2) -> void:
	position = ipos * Game.SNAP + Vector2.ONE * Game.SNAP / 2.0

func set_global_integer_position(ipos : Vector2) -> void:
	global_position = ipos * Game.SNAP + Vector2.ONE * Game.SNAP / 2.0

func get_integer_position() -> Vector2:
	return Util.floor_v2(position / Game.SNAP)

func get_global_integer_position() -> Vector2:
	return Util.floor_v2(global_position / Game.SNAP)

func is_moving() -> bool:
	return move_cooldown_timer.time_left != 0.0

# EXTERNALLY CALLABLE
# Queue a move to be processed
func queue_move(_direction : Vector2, _priority : int = 0) -> void:
# warning-ignore:return_value_discarded
	queued_move.set_move(_direction, _priority)

# Checks if the relative block in direction is solid
func check_solid_relative(dir : Vector2) -> bool:
	return WorldGrid.solid_grid.get_cell_at_pixel(global_position + dir * Game.SNAP) == 0

# Move the character by a square
func move_position(dir : Vector2) -> void:
	move_cooldown_timer.stop()
	
	var _move_distance = dir * Game.SNAP
	
	if solid:
		WorldGrid.solid_grid.move_solid(get_global_integer_position(), dir)
	
	position += _move_distance
	last_move = dir
	move_cooldown_timer.start(get_move_duration())

# UTILITY
static func get_random_move_direction() -> Vector2:
	return VDIRECTION[randi() % DIRECTION._MAX]

static func get_travel_duration(distance : float, speed : float) -> float:
	return distance / speed

func snap_to_grid():
	position = Util.snap_v2(position, Game.SNAP) + Vector2.ONE * Game.SNAP / 2
