extends KinematicBody

class_name CharacterController3D

export var movementSpeed: float = 4.0

func _ready():
	pass

func _physics_process(delta):
# warning-ignore:return_value_discarded
	move_and_slide(movement() * movementSpeed * delta)

func movement() -> Vector3:
	return Vector3(float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")), 0.0, float(Input.is_action_pressed("move_down")) - float(Input.is_action_pressed("move_up"))).normalized()
