extends Area2D

class_name Interactable2D

export(bool) var can_be_peered

func _enter_tree():
# warning-ignore:integer_division
# warning-ignore:integer_division
	$interactable_hitbox_2d.shape.extents = Vector2(Game.SNAP / 2 - 1, Game.SNAP / 2 - 1)

func get_rect() -> Rect2:
	var _extents = $interactable_hitbox_2d.shape.extents * scale
	return Rect2($interactable_hitbox_2d.global_position - _extents, _extents * 2.0)

func step():
	print("Default step function called")

func interact():
	print("Default interact function called")
