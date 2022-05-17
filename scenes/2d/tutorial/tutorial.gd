extends "res://scenes/2d/transition manager/transition_manager.gd"

export(Array, Texture) var tutorials

export(int) var tutorial_index setget set_tutorial_index
func set_tutorial_index(val : int) -> void:
	tutorial_index = val
	material.set_shader_param("transition_texture", tutorials[tutorial_index])

var active : bool = false setget set_active
func set_active(val : bool) -> void:
	if active != val:
		if val:
			play_transition()
			wait_time = -1.0
			set_tutorial_index(0)
		else:
			if state == TransitionState.WAIT:
				next_state()
			else:
				wait_time = 0.0
	
	if PlayerAccess.player_3d_exists(get_tree()):
		var _player = PlayerAccess.get_player_3d(get_tree())
		_player.set_frozen(name, val)
	
	active = val

signal tutorial_finished

func accepting_accept_input() -> bool:
	return active && state == TransitionState.WAIT

func accept_input_just_pressed() -> bool:
	return Input.is_action_just_pressed("interact")

func _ready() -> void:
	Util.connect_safe(self, "transition_finished", self, "_on_transition_finished")

func _process(delta: float) -> void:
	if accepting_accept_input() && accept_input_just_pressed():
		next_state()

func _on_transition_finished() -> void:
	set_tutorial_index((tutorial_index + 1) % tutorials.size())
	if tutorial_index != 0:
		play_transition()
	else:
		set_active(false)
		emit_signal("tutorial_finished")
