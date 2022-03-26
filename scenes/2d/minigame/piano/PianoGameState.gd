extends Node

class_name PianoGameState

var minigame
var spawner
var arrow

func initialize(_minigame, _spawner, _arrow):
	minigame = _minigame
	spawner = _spawner
	arrow = _arrow

# Called when set as current state
func added():
	pass

# Called when removed
func removed():
	pass

# Called every bar of the rhythm game's song
func bar():
	pass

# Called every beat of the rhythm game's song
func rhythm():
	pass

func spawn_bar():
	pass

func spawn_rhythm():
	pass
