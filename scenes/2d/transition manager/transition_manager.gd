extends TextureRect

enum TransitionState {NONE, IN, WAIT, OUT, _MAX}
var state = TransitionState.NONE setget set_state
func set_state(val) -> void:
	pass
func _set_state(val) -> void:
	if val != state:
		state = val
		match val:
			TransitionState.NONE:
				animation = 0.0
			TransitionState.IN:
				$animation_tween.interpolate_property(self, "animation", 0.0, 1.0, transition_duration, tween_type)
				$animation_tween.start()
			TransitionState.WAIT:
				if wait_time > 0.0:
					get_tree().create_timer(wait_time).connect("timeout", self, "_on_TransitionWaitTimer_timeout")
				else:
					_next_state()
			TransitionState.OUT:
				match transition_type:
					TransitionType.FORWARD:
						$animation_tween.interpolate_property(self, "animation", null, 2.0, transition_duration, tween_type)
					TransitionType.FORWARD_BACK:
						$animation_tween.interpolate_property(self, "animation", null, 0.0, transition_duration, tween_type)
				$animation_tween.start()
				emit_signal("transition_middle")
func _next_state() -> void:
	_set_state((state + 1) % TransitionState._MAX)

enum TransitionType {FORWARD, FORWARD_BACK}
export(TransitionType) var transition_type = TransitionType.FORWARD_BACK

var animation := 0.0

## @desc: Decides how the transition will be tweened
export(int) var tween_type = Tween.TRANS_SINE
## @desc: Duration of a transition in seconds
export(float, 0.0, 2.0) var transition_duration = 1.0
## @desc: Wait time between transitioning in and out
export(float, 0.0, 1.0) var wait_time = 0.1

signal transition_middle

func play_transition() -> void:
	_set_state(TransitionState.IN)

func _ready() -> void:
	$animation_tween.connect("tween_all_completed", self, "_on_animation_tween_tween_all_completed")
	rect_size = get_viewport_rect().size

func _process(delta: float) -> void:
	material.set_shader_param("animation", animation)

func _on_animation_tween_tween_all_completed():
	_next_state()

func _on_TransitionWaitTimer_timeout():
	_next_state()
