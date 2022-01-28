extends Node2D

class_name Character2D

var move_cooldown_length := 0.4
var move_cooldown_timer := Timer.new()

func _ready():
	add_child(move_cooldown_timer)
	move_cooldown_timer.one_shot = true

func is_movable() -> bool:
	return move_cooldown_timer.time_left == 0.0

func move(dir : Vector2) -> void:
	var _move_distance = dir * Game.SNAP
	position += _move_distance
	move_cooldown_timer.start(move_cooldown_length)

func check_solid_relative(dir : Vector2) -> bool:
	var _check_position = global_position + dir * Game.SNAP
	var _cell = SolidGrid.get_cellv(SolidGrid.world_to_map(_check_position))
	return Util.tern(_cell == TileMap.INVALID_CELL, false, true)
