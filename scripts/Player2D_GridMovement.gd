extends KinematicBody2D

class_name Player2D

var move_distance : Vector2
var grid := 24.0
var walk_speed := 200.0

func get_input_vector() -> Vector2:
	var _horizontal_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return Vector2(
		_horizontal_movement,
		(Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * (_horizontal_movement == 0) as int)

func is_moving() -> bool:
	return move_distance.x != 0 || move_distance.y != 0

#TODO: This sorta simulates a tween (could be simplified using one)
func _physics_process(delta):
	var _input_vector = get_input_vector()
	var _attempting_move = _input_vector.x != 0 || _input_vector.y != 0
	
	if _attempting_move && !is_moving() && !move_and_collide(_input_vector * grid, true, true, true):
		move_distance = _input_vector * grid;
	
	if is_moving():
		var _movement_speed = walk_speed * delta
		var _movement_direction = move_distance.normalized()
		var _movement_distance = Vector2(
			min(abs(move_distance.x), abs(_movement_direction.x * _movement_speed)) * sign(move_distance.x),
			min(abs(move_distance.y), abs(_movement_direction.y * _movement_speed)) * sign(move_distance.y))
		
		var result = move_and_collide(_movement_distance)
		
		if !result:
			move_distance -= _movement_distance
		else:
			print("what?")
