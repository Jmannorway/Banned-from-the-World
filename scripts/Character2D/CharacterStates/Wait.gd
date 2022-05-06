extends CharacterState

var timer : SceneTreeTimer
export(float) var duration = 1.0
var next_state : String

func enter():
	next_state = KEEP_STATE
	timer = get_tree().create_timer(duration)
	timer.connect("timeout", self, "_timeout")

func process(delta : float) -> String:
	return next_state

func exit():
	if is_instance_valid(timer):
		Util.disconnect_safe(timer, "timeout", self, "_timeout")

func _timeout():
	next_state = POP_STATE
