extends AnimatedSprite

export(float) var radius
export(float) var travel_duration := 0.75
var direction : Vector2
var goal_position : Vector2

func is_moving() -> bool:
	return $Tween.is_active()

func _process(delta: float) -> void:
	$Shadow.frame = frame

func _input(event: InputEvent) -> void:
	var _input = Player2D.make_input_vector_4way(Player2D.get_input_vector())
	if !_input.is_equal_approx(Vector2.ZERO) && !_input.is_equal_approx(direction):
		var _new_position
		var _new_direction
		if _input.dot(direction) == -1.0:
			_new_position = Vector2.ZERO
			_new_direction = Vector2.ZERO
		else:
			_new_position = _input * radius
			_new_direction = _input
		
		if _new_direction.is_equal_approx(Vector2.ZERO) || Statistics.is_checkpoint_unlocked_direction(_new_direction):
			direction = _new_direction
			$Tween.remove_all()
			$Tween.interpolate_property(self, "position", null, _new_position, position.distance_to(_new_position) / radius * travel_duration, Tween.TRANS_SINE)
			$Tween.start()
