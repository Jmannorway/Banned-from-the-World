extends Area2D

class_name Interactable2D

func _enter_tree():
# warning-ignore:integer_division
# warning-ignore:integer_division
	$interactable_hitbox_2d.shape.extents = Vector2(Game.SNAP / 2 - 1, Game.SNAP / 2 - 1)

func step():
	print("Default step function called")

func interact():
	print("Default interact function called")
