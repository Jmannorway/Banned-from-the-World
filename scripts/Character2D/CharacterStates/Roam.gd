extends CharacterState

export(float) var delay = 1.0
export(float) var delay_rand = 0.75
var timer : SceneTreeTimer
var move : bool

func set_move_timer(var dur):
	timer = get_tree().create_timer(dur)
	timer.connect("timeout", self, "_on_delay_timer_timeout")

func unset_move_timer():
	if is_instance_valid(timer):
		Util.disconnect_safe(timer, "timeout", self, "_on_delay_timer_timeout")

func process(delta : float) -> String:
	if move:
		var _move = Character2DBase.get_random_move_direction()
		if !character.check_solid_relative(_move):
			character.queue_move(_move, 0)
			return "move"
		else:
			character.set_facing(_move)
			set_move_timer(get_move_delay())
	return KEEP_STATE

func enter():
	move = false
	set_move_timer(get_move_delay())

func exit():
	unset_move_timer()

func get_move_delay() -> float:
	return delay - randf() * delay_rand * delay

func _on_delay_timer_timeout():
	move = true
