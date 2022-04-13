extends Character2D

onready var move_timer = $move_timer

func _on_move_timer_timeout():
	var _move = get_random_move_direction()
	if !check_solid_relative(_move):
		queue_move(get_random_move_direction(), 0)
	else:
		sprite.set_sprite_direction(_move)
