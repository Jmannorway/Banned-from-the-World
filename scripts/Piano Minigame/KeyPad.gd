extends Area2D

var keysInScope: Array

func _ready():
# warning-ignore:return_value_discarded
	connect("area_shape_entered", self, "add_key")
# warning-ignore:return_value_discarded
	connect("area_shape_exited", self, "remove_key")

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func add_key(var areaRID: RID, var otherArea2D: Area2D, var shapeID: int, var localShapeID: int) -> void:
	keysInScope.append(otherArea2D.shape_owner_get_owner(shapeID))

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func remove_key(var areaRID: RID, var otherArea2D: Area2D, var shapeID: int, var localShapeID: int) -> void:
	var _key = otherArea2D.shape_owner_get_owner(shapeID)
	var _index: int = keysInScope.find(_key)
	
	if _index >= 0:
		_key.emit_signal("remove_key")
		keysInScope.remove(_index)
