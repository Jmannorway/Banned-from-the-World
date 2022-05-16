tool

extends Interactable2D

class_name Stairs

export var width: int = 3 setget set_width
export var offsetPerBlock: int = 4 setget set_move_offset
export var addElevation: int = 1 setget set_elevation
export var length: int = 1 setget set_length
export (int, "Up", "Down", "Left", "Right") var walkUpDirection: int setget set_walk_up_direction

var moveBlockOffsetAmount: float
var enteredFromShapeIndex: int = -1

var enteredFrom: Vector2
var objectRef: Player2D
var isInStairs: bool

signal change_floors(floorToAdd)

func set_walk_up_direction(var value: int) -> void:
	walkUpDirection = value
	update_stairs_area()

func set_length(var value: int) -> void:
	length = value
	update_stairs_area()

func set_width(var value: int) -> void:
	width = value
	update_stairs_area()

func set_move_offset(var value: int) -> void:
	offsetPerBlock = value
	moveBlockOffsetAmount = (1.0 / float(offsetPerBlock)) if offsetPerBlock != 0 else 0.0
	update_stairs_area()

func set_elevation(var value: int) -> void:
	addElevation = value
	update_stairs_area()

func _ready():
	if !Engine.editor_hint:
		moveBlockOffsetAmount = (1.0 / float(offsetPerBlock)) if offsetPerBlock != 0 else 0.0
		
# warning-ignore:return_value_discarded
		connect("area_shape_entered", self, "on_stairs_walking")
# warning-ignore:return_value_discarded
		connect("area_shape_exited", self, "on_stairs_exiting")
		
#		objectRef = PlayerAccess.get_player_2d(get_tree())

func update_stairs_area() -> void:
	if !has_node("stairs_field"):
		return
	
	if $stairs_field.polygon.size() != 4:
		$stairs_field.polygon.resize(4)
	
	var _offset: Vector2 = Vector2.ONE * Game.SNAP * 0.5
	var _mirror: float = 1.0 if walkUpDirection == 2 or walkUpDirection == 0 else -1.0
	var _horizontal: float = float(walkUpDirection == 2 or walkUpDirection == 3)
	var _vertical: float = float(walkUpDirection == 0 or walkUpDirection == 1)
	
	_offset.x *= -_mirror * _horizontal
	_offset.y *= _mirror * _vertical
	
	var _halfWidth: float = width * 0.5
	
	_offset *= -1.0
	
	$stairs_field.polygon[0] = Vector2(-_halfWidth * _vertical, _halfWidth * _horizontal) * Game.SNAP + _offset
	$stairs_field.polygon[1] = Vector2(_halfWidth * _vertical, -_halfWidth * _horizontal) * Game.SNAP + _offset
	
	_offset *= -1.0
	
	if _vertical > 0.5:
#		$stairs_field.polygon[0].y *= -_mirror
#		$stairs_field.polygon[1].y *= -_mirror
		$stairs_field.polygon[2] = Vector2($stairs_field.polygon[1].x, -_mirror * length * Game.SNAP + _offset.y)
		$stairs_field.polygon[3] = Vector2($stairs_field.polygon[0].x, -_mirror * length * Game.SNAP + _offset.y)
		return
	
	var _extension: float = (length * offsetPerBlock - 1.0) * -_mirror
	var _tail: float = _halfWidth - length + moveBlockOffsetAmount
	var _tail2: float = -_halfWidth - length + moveBlockOffsetAmount
	
	_offset *= -1.0
	
	$stairs_field.polygon[2] = Vector2(_extension * _horizontal + _tail * _vertical, _tail2 * _horizontal - _extension * _vertical) * Game.SNAP + _offset
	$stairs_field.polygon[3] = Vector2(_extension * _horizontal + _tail2 * _vertical, _tail * _horizontal - _extension * _vertical) * Game.SNAP + _offset

func step() -> void:
	pass

# warning-ignore:unused_argument
func on_character_enter(var directionFrom: Vector2) -> void:
	enteredFrom = directionFrom
	
	if objectRef == null:
		printerr("[ERROR] : No object found to set offset.")
		
		return
	
	match walkUpDirection:
		2:
			objectRef.set_move_offset(Vector2(0.0, moveBlockOffsetAmount))
		3:
			objectRef.set_move_offset(Vector2(0.0, -moveBlockOffsetAmount))

# warning-ignore:unused_argument
func on_character_exit(var directionTo: Vector2) -> void:
	if objectRef == null:
		printerr("[ERROR] : No reference set for the stairs to control")
		return
	
	objectRef.move_offset.y = 0.0
	
	if directionTo != enteredFrom:
		return
	
	match walkUpDirection:
		0: # UP
			if objectRef.global_position.y < global_position.y:
				get_parent().get_parent().set_relative_floor(addElevation)
			else:
				get_parent().get_parent().set_relative_floor(-addElevation)
		1: # DOWN
			if objectRef.global_position.y > global_position.y:
				get_parent().get_parent().set_relative_floor(addElevation)
			else:
				get_parent().get_parent().set_relative_floor(-addElevation)
		2: # LEFT
			if objectRef.global_position.x < global_position.x:
				get_parent().get_parent().set_relative_floor(addElevation)
			else:
				get_parent().get_parent().set_relative_floor(-addElevation)
		3: # RIGHT
			if objectRef.global_position.x > global_position.x:
				get_parent().get_parent().set_relative_floor(addElevation)
			else:
				get_parent().get_parent().set_relative_floor(-addElevation)
	
#	print("on exit ", directionTo)
#
#	if is_in_stairs() and !isInStairs:
#		isInStairs = true
#		if enteredFromShapeIndex == 1:
#			objectRef.move_offset.y = moveBlockOffsetAmount
#	else:
#		if enteredFromShapeIndex == 1:
#			objectRef.move_offset.y = 0.0
#		objectRef = null
#		isInStairs = false

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func on_stairs_exiting(var areaRID: RID, var area, var shapeID: int, var localShapeID: int) -> void:
	pass
#	if !isInStairs:
#		emit_signal("change_floors", addElevation * int(enteredFromShapeIndex != localShapeID) * (1.0 if enteredFromShapeIndex == 0 else -1.0))
#
#		enteredFromShapeIndex = -1

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func on_stairs_walking(var areaRID: RID, var area: Area2D, var shapeID: int, var localShapeID: int) -> void:
	objectRef = area.get_parent()
#	if enteredFromShapeIndex < 0:
#		# enter stair
#		enteredFromShapeIndex = localShapeID
#		objectRef = area.get_parent()
#
#		if enteredFromShapeIndex == 0:
#			objectRef.move_offset.y = moveBlockOffsetAmount

#func is_in_stairs() -> bool:
#	if objectRef == null:
#		return false
#
#	match walkUpDirection:
#		0:
#			return is_in_between(objectRef.global_position.y, $bottom_col.global_position.y, $top_col.global_position.y)
#		1:
#			return is_in_between(objectRef.global_position.y, $top_col.global_position.y, $bottom_col.global_position.y)
#		2:
#			return is_in_between(objectRef.global_position.x, $top_col.global_position.x, $bottom_col.global_position.x)
#		3:
#			return is_in_between(objectRef.global_position.x, $bottom_col.global_position.x, $top_col.global_position.x)
#
#	return false
#
#func is_in_between(var value: float, var minV: float, var maxV: float) -> bool:
#	return minV <= value and maxV >= value
