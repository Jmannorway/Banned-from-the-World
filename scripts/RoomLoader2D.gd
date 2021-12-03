tool

extends Node2D

class_name RoomLoader2D

export var room : PackedScene
export var loaded := false setget set_loaded
export var size := Vector2(320, 320) setget set_size

func load_room() -> void:
	add_child(room.instance())

func unload_room() -> void:
	for child in get_children():
		child.queue_free()

func set_size(val : Vector2) -> void:
	size = val
	update()

func set_loaded(val : bool) -> void:
	if val && !loaded:
		load_room()
	elif !val && loaded:
		unload_room()
	loaded = val

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(Vector2.ZERO, size), Color.white, false)
