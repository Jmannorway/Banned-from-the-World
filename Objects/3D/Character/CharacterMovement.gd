extends Tween

class_name CharacterMovement

var position_delta : Vector3
var direction : Vector3
var speed : float
var distance : float
var previous_distance : float
var total_distance : float

# Get the amount of pixels to move since last frame
func get_position_delta() -> Vector3:
	return position_delta

func get_position_delta_2d() -> Vector2:
	return Vector2(position_delta.x, position_delta.y)

func is_moving() -> bool:
	return distance > 0

func move(delta : Vector3, spd : float) -> void:
	position_delta = Vector3.ZERO
	direction = delta.normalized()
	total_distance = delta.length()
	previous_distance = total_distance
	interpolate_property(self, "distance", total_distance, 0, total_distance / spd)
	start()

func move_2d(delta : Vector2, spd : float) -> void:
	move(Vector3(delta.x, delta.y, 0), spd)

func _on_CharacterMovement_tween_step(object, key, elapsed, value):
	position_delta = (previous_distance - distance) * direction
	previous_distance = distance

func _on_CharacterMovement_tween_completed(object, key):
	set_deferred("position_delta", Vector3.ZERO)
