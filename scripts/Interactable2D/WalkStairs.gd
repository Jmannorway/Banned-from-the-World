extends Area2D

class_name Stairs

export var addElevation: int = 1
export (int, "Up", "Down", "Left", "Right") var walkUpDirection: int

var moveBlockOffsetAmount: float
var enteredFromShapeIndex: int = -1

var objectRef: Node2D

signal change_floors(floorToAdd)

func _ready():
	var _stairsMove: Vector2 = ($top_col.global_position - $bottom_col.global_position) / 24.0
	moveBlockOffsetAmount = _stairsMove.y / _stairsMove.x
	
# warning-ignore:return_value_discarded
	connect("area_shape_entered", self, "on_stairs_walking")
# warning-ignore:return_value_discarded
	connect("area_shape_exited", self, "on_stairs_exiting")

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func on_stairs_exiting(var areaRID: RID, var area, var shapeID: int, var localShapeID: int) -> void:
	if !is_in_stairs():
		objectRef = null
		emit_signal("change_floors", addElevation * int(enteredFromShapeIndex != localShapeID) * (1.0 if enteredFromShapeIndex == 0 else -1.0))
		enteredFromShapeIndex = -1

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func on_stairs_walking(var areaRID: RID, var area: Area2D, var shapeID: int, var localShapeID: int) -> void:
	if enteredFromShapeIndex < 0:
		# enter stair
		enteredFromShapeIndex = localShapeID
		objectRef = area.get_parent()

func is_in_stairs() -> bool:
	if objectRef == null:
		return false
	
	match walkUpDirection:
		0:
			return is_in_between(objectRef.global_position.y, $bottom_col.global_position.y, $top_col.global_position.y)
		1:
			return is_in_between(objectRef.global_position.y, $top_col.global_position.y, $bottom_col.global_position.y)
		2:
			return is_in_between(objectRef.global_position.x, $top_col.global_position.x, $bottom_col.global_position.x)
		3:
			return is_in_between(objectRef.global_position.x, $bottom_col.global_position.x, $top_col.global_position.x)
	
	return false

func is_in_between(var value: float, var minV: float, var maxV: float) -> bool:
	return minV <= value and maxV >= value
