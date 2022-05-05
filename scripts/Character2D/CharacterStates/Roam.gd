extends CharacterState

export(float) var delay = 1.0
var timer : SceneTreeTimer
var move : bool

func set_move_timer():
	timer = get_tree().create_timer(delay)
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
			set_move_timer()
	return ""

func enter():
	move = false
	set_move_timer()

func exit():
	unset_move_timer()

func _on_delay_timer_timeout():
	move = true
