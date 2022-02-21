tool

extends Node2D

class_name RoomLoader2D

# TODO: Currently loading in this class refers to two fundamentally different things
# this needs to change to mitigate confusions in the future

export var room_name : String
export var room : PackedScene
var room_instance : Node

export var preview := false setget set_preview
export var size := Vector2(480, 360) setget set_size
var loaded := false setget set_loaded

signal loaded
signal unloaded

func set_preview(val) -> void:
	if Engine.editor_hint:
		set_loaded(val)
		preview = loaded

func get_global_middle() -> Vector2:
	return global_position + size / 2.0

func is_loaded() -> bool:
	return loaded

func set_size(val : Vector2) -> void:
	size = val
	update()

func set_loaded(val : bool) -> void:
	if val && !loaded:
		_load_room()
	elif !val && loaded:
		_unload_room()
	loaded = val

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(Vector2.ZERO, size), Color.white, false, 2.0)

func _enter_tree():
	if room_name.empty():
		room_name = name
	if !Engine.editor_hint:
		MapManager.get_room_manager().register_room_loader(self)

func _ready():
	$area/bounds.position = size / 2
	$area/bounds.shape.extents = size / 2

# INTERNAL FUNCTIONS
func _load_room():
	room_instance = room.instance()
	add_child(room_instance)
	emit_signal("loaded")

func _unload_room():
	if is_instance_valid(room_instance):
		room_instance.queue_free()
	room_instance = null
	emit_signal("unloaded")
