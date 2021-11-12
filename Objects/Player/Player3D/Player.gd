extends KinematicBody

var base = PlayerBase.new()
var grid : float = 1
var speed : float = base.speed
onready var movement : CharacterMovement = $CharacterMovement

func _process(delta):
	var input_vector = PlayerStatics.get_input_vector()
	if not movement.is_moving():
		movement.move(Vector3(input_vector.x, 0, input_vector.y) * grid, speed)

func _physics_process(delta):
	move_and_collide(movement.get_position_delta())
