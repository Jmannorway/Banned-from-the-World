tool

extends Area2D

class_name RoomLoader2D

# TODO: Currently loading in this class refers to two fundamentally different things
# this needs to change to mitigate confusions in the future

export var room_name : String
export var room : PackedScene
export var loaded := false setget set_loaded
export var size := Vector2(320, 320) setget set_size
var detection_margin := 16.0
var room_instance : Node

signal loaded
signal unloaded

func load_room() -> void:
	room_instance = room.instance()
	add_child(room_instance)
	emit_signal("loaded")

func unload_room() -> void:
	if room_instance:
		room_instance.queue_free()
		room_instance = null
		emit_signal("unloaded")

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

func _ready():
	$bounds.position = size / 2
	$bounds.shape.extents = size / 2 + Vector2.ONE * detection_margin

#func _on_room_loader_2d_body_entered(body : Player2D):
#	call_deferred("set_loaded", true)
#
#func _on_room_loader_2d_body_exited(body : Player2D):
#	call_deferred("set_loaded", false)
