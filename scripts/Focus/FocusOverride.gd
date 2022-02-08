extends Node

export(bool) var is_2d = true

func _ready():
	XToFocus.call_deferred("override", self, !is_2d)
