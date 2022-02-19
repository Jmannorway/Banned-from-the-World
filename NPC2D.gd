extends Character2D

onready var move_timer = $move_timer

func _on_move_timer_timeout():
	queue_move(get_random_move_direction(), 0)
