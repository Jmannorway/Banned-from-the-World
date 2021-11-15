tool

extends Object

class_name RoomLoader

var room_scene : PackedScene
var room : Node
var loaded : bool setget set_loaded
var target : Node

func unload_room() -> void:
	room.queue_free()

func load_room() -> void:
	room = target.add_child(room_scene.instance())

func set_loaded(val : bool) -> void:
	if room_scene:
		if loaded && !val:
			unload_room()
		elif !loaded && val:
			load_room()
		loaded = val
	else:
		print("Error: Room loader couldn't load room resource")

func _init(target_ : Node):
	target = target_
