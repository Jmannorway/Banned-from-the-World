tool

extends Area2D

class_name RoomLoader2D

# TODO: Currently loading in this class refers to two fundamentally different things
# this needs to change to mitigate confusions in the future

export var room_name : String
export var room : PackedScene
export var loaded := false setget set_loaded
export var size := Vector2(480, 360) setget set_size
var detection_margin := 16.0
var room_instance : Node

func get_global_middle() -> Vector2:
	return global_position + size / 2.0

func load_room() -> void:
	room_instance = room.instance()
	add_child(room_instance)

func unload_room() -> void:
	if room_instance:
		room_instance.queue_free()
		room_instance = null

func is_loaded() -> bool:
	return is_instance_valid(room_instance)

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

func _enter_tree():
	if room_name.empty():
		room_name = name
	MapManager.get_room_manager().register_room(self)

func _ready():
	$bounds.position = size / 2
	$bounds.shape.extents = size / 2 + Vector2.ONE * detection_margin
