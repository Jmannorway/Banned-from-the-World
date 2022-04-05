extends Node2D

# This class acts as the interface to the minigame

class InputCombo:
	var bind : String
	var direction : int
	func _init(_bind : String, _direction : int):
		bind = _bind
		direction = _direction

onready var minigame = $minigame
var inputs : Array

func _ready():
	inputs.push_back(InputCombo.new("move_up", Game.DIR4.UP))
	inputs.push_back(InputCombo.new("move_left", Game.DIR4.LEFT))
	inputs.push_back(InputCombo.new("move_right", Game.DIR4.RIGHT))
	inputs.push_back(InputCombo.new("move_down", Game.DIR4.DOWN))

func _process(delta):
	for i in inputs:
		if Input.is_action_just_pressed(i.bind):
			minigame.press(i.direction)
