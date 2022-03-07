extends Area2D

class_name Stairs

export (int, "Up", "Down", "Left", "Right") var walkUpDirection: int

func _ready():
	connect("area_shape_entered", self, "on_stairs_walking")

func on_stairs_walking(var areaRID: RID, var area, var shapeID: int, var localShapeID: int) -> void:
	var _stairsMove: Vector2 = $top_col.global_position - $bottom_col.global_position
	
	match walkUpDirection:
		0:
			_stairsMove.y -= 24.0
		1:
			_stairsMove.y += 24.0
		2:
			_stairsMove.x -= 24.0
		3:
			_stairsMove.x += 24.0
	
	_stairsMove *= 1.0 if localShapeID == 0 else -1.0
	
	area.get_parent().move_position(_stairsMove / 24.0)
