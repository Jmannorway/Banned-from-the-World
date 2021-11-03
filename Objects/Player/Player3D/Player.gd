extends KinematicBody

var base = PlayerBase.new()
var speed : float = base.speed

func _physics_process(delta):
	var input_vector = PlayerStatics.get_input_vector().normalized()
	move_and_slide(Vector3(input_vector.x, 0, input_vector.y) * base.speed * delta)
