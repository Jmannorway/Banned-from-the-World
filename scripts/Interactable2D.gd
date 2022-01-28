extends Area2D

class_name Interactable2D

func _enter_tree():
	$interactable_hitbox_2d.shape.extents = Vector2(Game.SNAP / 2 - 1, Game.SNAP / 2 - 1)

func step():
	print("yup")

func interact():
	print("nope")
