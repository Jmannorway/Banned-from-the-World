extends Node2D

export var scoreByDistance: PoolRealArray

onready var tween: Tween = $tween_rotation
onready var keyPad: Node2D = $key_pad

var currentScore: int

signal score_appended(score)

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var _randomDirection: int = randi() % 4
		
		match _randomDirection:
			Direction.UP:
# warning-ignore:return_value_discarded
				tween.interpolate_property(keyPad, "rotation", null, PI, 1.4)
			Direction.DOWN:
# warning-ignore:return_value_discarded
				tween.interpolate_property(keyPad, "rotation", null, 0.0, 1.4)
			Direction.LEFT:
# warning-ignore:return_value_discarded
				tween.interpolate_property(keyPad, "rotation", null, PI * 0.5, 1.4)
			Direction.RIGHT:
# warning-ignore:return_value_discarded
				tween.interpolate_property(keyPad, "rotation", null, -PI * 0.5, 1.4)
		
# warning-ignore:return_value_discarded
		tween.start()

func append_score(var distance: float) -> void:
	var _score: int # 0 is the worst score
	
	for i in scoreByDistance.size():
		if scoreByDistance[i] >= distance:
			_score = abs(i - scoreByDistance.size())
			break
	
	print("Score: ", _score, " Distance: ", distance)
	
	currentScore += _score
	emit_signal("score_appended", _score)

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
