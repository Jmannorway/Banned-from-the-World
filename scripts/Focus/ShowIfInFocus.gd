extends Node

func _ready():
	set("visible", XToFocus.is_in_focus(self))
