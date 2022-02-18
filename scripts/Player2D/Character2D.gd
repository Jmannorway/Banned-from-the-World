extends Node2D

class_name Character2D 

export var isSolid: bool = true

var move_cooldown_length := 0.5
var move_cooldown_timer := Timer.new()

func set_move_speed(squares_per_second) -> void:
	move_cooldown_length = 1 / squares_per_second

func _ready():
	add_child(move_cooldown_timer)
	move_cooldown_timer.one_shot = true

func is_movable() -> bool:
	return move_cooldown_timer.time_left == 0.0

func move(dir : Vector2) -> void:
	var _move_distance = dir * Game.SNAP
	
	if isSolid:
		WorldGrid.solid_grid.move_solid(position, _move_distance)
	
	position += _move_distance
	move_cooldown_timer.start(move_cooldown_length)

func check_solid_relative(dir : Vector2) -> bool:
	return WorldGrid.solid_grid.get_cell_at_pixel(global_position + dir * Game.SNAP) == 0
