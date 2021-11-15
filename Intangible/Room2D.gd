tool

extends Node2D

class_name Room2D

var room_loader := RoomLoader.new(self)
export var room_scene : PackedScene
export var size := Vector2(240, 240) setget set_size
export var loaded : bool setget set_loaded

func set_loaded(val : bool) -> void:
	loaded = val
	room_loader.set_loaded(loaded)

func set_size(new_size : Vector2) -> void:
	size = new_size
	update()

func _ready() -> void:
	room_loader.room_scene = room_scene
	set_loaded(loaded)

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), Color.white, false)
