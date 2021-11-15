tool

extends Node2D

export var size : Vector2 = Vector2(320, 240) setget set_size

func set_size(new_size : Vector2) -> void:
	size = new_size
	material.set_shader_param("u_size", size)
	update()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), modulate)

func _process(delta):
	material.set_shader_param("u_position", position)
