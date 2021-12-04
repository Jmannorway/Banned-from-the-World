extends Area2D

class_name Interactable2D

signal interacted

func interact() -> void:
	emit_signal("interacted")
