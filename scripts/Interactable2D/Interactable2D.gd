extends Area2D

class_name Interactable2D

func _enter_tree():
	if get_child_count() <= 0:
		var _defaultShape: CollisionShape2D = CollisionShape2D.new()
		var _rectShape: RectangleShape2D = RectangleShape2D.new()
		
		_rectShape.extents = Vector2(Game.SNAP / 2 - 1, Game.SNAP / 2 - 1)
		_defaultShape.shape = _rectShape
		add_child(_defaultShape)

func get_rect() -> Rect2:
	var _extents = $interactable_hitbox_2d.shape.extents * scale
	return Rect2($interactable_hitbox_2d.global_position - _extents, _extents * 2.0)

func step():
	print("Default step function called")

func interact():
	print("Default interact function called")

func on_character_enter(var directionFrom: Vector2) -> void:
	print("Default on enter from: ", directionFrom)

func on_character_exit(var directionTo: Vector2) -> void:
	print("Default on exit to: ", directionTo)
