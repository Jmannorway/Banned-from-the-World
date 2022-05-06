extends CharacterState

var move_finished : bool

func init(_character):
	.init(_character)
	Util.connect_safe(character, "move_finished", self, "_on_move_finished")

func enter():
	move_finished = false

func process(delta: float) -> String:
	if move_finished:
		return "_"
	else:
		return ""

func _on_move_finished():
	move_finished = true
