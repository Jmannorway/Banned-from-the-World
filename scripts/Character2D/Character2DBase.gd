extends Node2D

class_name Character2DBase

# Class that holds data and logic for queueing moves
class CharacterMove2D:
	var steps : Vector2
	var direction : Vector2
	var priority : int
	const PRIORITY_MIN = -9999999
	const PRIORITY_UNSET = PRIORITY_MIN - 1

	func _init() -> void:
		clear()
	func set_move(_steps : Vector2, _direction : Vector2, _priority : int) -> bool:
		if priority < _priority:
			priority = _priority
			steps = _steps
			direction = _direction
			return true
		else:
			return false
	func is_move_set() -> bool:
		return priority != PRIORITY_UNSET
	func clear() -> void:
		priority = PRIORITY_UNSET
		steps = Vector2.ZERO

enum DIRECTION {RIGHT, UP, LEFT, DOWN, _MAX}

const VDIRECTION = [
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.LEFT,
	Vector2.DOWN]

const GROUP_NAME := "characters"

enum MOBILITY {
	NORMAL,		# Can't walk through walls or tiles tagged as void
	FLYING,		# Can walk through tiles tagged as void,
	GHOST		# Can walk through any tile
}

signal changed_facing_direction(facing)
signal move_started
signal move_finished

export var solid := true
export(MOBILITY) var mobility = MOBILITY.NORMAL # TODO: Implement
export(float, 0.1, 16.0) var move_speed = 2.0 setget set_move_speed

var move_offset : Vector2
var move_cooldown_timer := Timer.new()
var queued_move := CharacterMove2D.new()
var facing := Vector2.DOWN setget set_facing
var last_move : Vector2
var layer : int = 0

var lastSolidIndex: int = TileMap.INVALID_CELL

# INTERNAL FUNCTIONS
func _enter_tree():
	snap_to_grid()
# warning-ignore:return_value_discarded
	add_to_group(GROUP_NAME)

	Util.connect_safe(get_tree(), "physics_frame", self, "_process_move")
	Util.connect_safe(get_tree(), "idle_frame", self, "update_solidity")

	var _room = MapManager.get_room_manager().get_current_room_loader()
	if _room && _room.looping:
		_room.make_character_looping(self)

	if !move_cooldown_timer.is_inside_tree():
		add_child(move_cooldown_timer)
		move_cooldown_timer.one_shot = true
		Util.connect_safe(move_cooldown_timer, "timeout", self, "_on_move_cooldown_timer_timeout")

# general move function
func _move(steps : Vector2, direction : Vector2) -> void:
	move_position(steps)
	set_facing(direction)
	emit_signal("move_started")

# Process the queued move
func _process_move() -> void:
	if !is_moving() && queued_move.is_move_set():
		_move(queued_move.steps, queued_move.direction)

	queued_move.clear()
	_post_process_move()

# Override for post movement behavior
func _post_process_move() -> void:
	pass

# Callbacks
func update_solidity() -> void:
	pass
#	if solid:
#		WorldGrid.get_solid_grid(layer).set_solid_at_pixel(global_position, true)

# SETTERS & GETTERS
func set_move_speed(val : float) -> void:
	if val > 0.0:
		move_speed = val

func set_move_offset(val : Vector2) -> void:
	move_offset = val
	if is_moving():
		move_position(-last_move)
		move_position(calculate_move_offset(facing))

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

func calculate_move_offset(steps : Vector2) -> Vector2:
	return steps + Vector2(move_offset.x * steps.y, move_offset.y * steps.x)

# EXTERNALLY CALLABLE
# Queue a move to be processed
func queue_move(_direction : Vector2, _priority : int = 0) -> bool:
	return queued_move.set_move(calculate_move_offset(_direction), _direction, _priority)

# Checks if the relative block in direction is solid
func check_solid_relative(steps : Vector2) -> bool:
	return WorldGrid.get_solid_grid(layer).get_cell_at_pixel(
		global_position + calculate_move_offset(steps) * Game.SNAP) != -1

# UP = 1
# RIGHT = 2
# DOWN = 4
# LEFT = 8

func check_solid_direction(var steps: Vector2, var stepIndex: int) -> bool:
#	var _selfTile: int = WorldGrid.get_solid_grid(layer).get_cell_at_pixel(global_position)
	var _stepTile: int = WorldGrid.get_solid_grid(layer).get_cell_at_pixel(global_position + calculate_move_offset(steps) * Game.SNAP)
	var _stepValue: int = stepIndex + 3 * (2 if stepIndex >= 8 else 1) * (-1 if stepIndex >= 4 else 1)
	
	return (_stepTile & stepIndex) as bool and _stepTile >= 0 # or (_selfTile & (stepIndex)) as bool

# Move the character by a square
func move_position(steps : Vector2) -> void:
	var _move_distance = steps * Game.SNAP
	
	if solid:
		WorldGrid.get_solid_grid(layer).move_solid_to_pixel_deprecated(global_position, _move_distance)
	
	position += _move_distance
	last_move = steps
	move_cooldown_timer.stop()
	move_cooldown_timer.start(get_move_duration())

# UTILITY
static func get_random_move_direction() -> Vector2:
	return VDIRECTION[randi() % DIRECTION._MAX]

static func get_travel_duration(distance : float, speed : float) -> float:
	return distance / speed

func snap_to_grid():
	position = Util.snap_v2(position, Game.SNAP) + Vector2.ONE * Game.SNAP / 2

# Callbacks
func _on_move_cooldown_timer_timeout():
	emit_signal("move_finished")
