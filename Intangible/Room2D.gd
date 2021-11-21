tool

extends Node2D

class_name Room2D

export var size := Vector2(240, 240) setget set_size
export var loaded : bool setget set_loaded
export var room_scene : PackedScene
var room : Node

func set_size(new_size : Vector2) -> void:
	size = new_size
	update()

func unload_room() -> void:
	if room:
		room.queue_free()
		room = null

func load_room() -> void:
	if !room:
		room = add_child(room_scene.instance())

func set_loaded(val : bool) -> void:
	if room_scene:
		if loaded && !val:
			unload_room()
		elif !loaded && val:
			load_room()
		loaded = val
	else:
		print("Error: Room loader couldn't load room resource")

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), Color.white, false)
