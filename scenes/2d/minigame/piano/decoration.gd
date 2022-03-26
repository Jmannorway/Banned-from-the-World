extends Node2D

enum STATE{TUTORIAL, PLAYING}
export(STATE) var state setget set_state
func set_state(val : int):
	state = val
	match state:
		STATE.TUTORIAL:
			$teacher.visible = false
		STATE.PLAYING:
			$teacher.visible = true

func _ready():
	set_state(state)
