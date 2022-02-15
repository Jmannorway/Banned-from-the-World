extends CollisionShape2D

export var activeColor: Color = Color.white
export (int, "Up", "Down", "Left", "Right")var direction: int

var keysInScope: Array

const pointThreashold: float = 24.0
const disabledColor: Color = Color(0.4, 0.4, 0.4)
const directionNames: Array = [ "up", "down", "left", "right" ]

func _ready():
	modulate = disabledColor
	
# warning-ignore:return_value_discarded
	get_parent().connect("area_shape_entered", self, "add_key")
# warning-ignore:return_value_discarded
	get_parent().connect("area_shape_exited", self, "remove_key")

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("move_" + directionNames[direction]):
		modulate = activeColor
		punch_key()
	elif Input.is_action_just_released("move_" + directionNames[direction]):
		modulate = disabledColor

func punch_key() -> void:
	if keysInScope.empty():
		return
	
	var _firstKey: CollisionShape2D = keysInScope[0]
	keysInScope.remove(0)
	
	get_parent().get_parent().append_score(global_position.distance_to(_firstKey.global_position))

# warning-ignore:unused_argument
func add_key(var areaRID: RID, var otherArea2D: Area2D, var shapeID: int, var localShapeID: int) -> void:
	if self == get_parent().shape_owner_get_owner(localShapeID):
		keysInScope.append(otherArea2D.shape_owner_get_owner(shapeID))

func remove_key(var areaRID: RID, var otherArea2D: Area2D, var shapeID: int, var localShapeID: int) -> void:
	var _index: int = keysInScope.find(otherArea2D.shape_owner_get_owner(shapeID))
	
	if _index >= 0:
		keysInScope.remove(_index)
