extends KinematicBody

var speed = 4
var interactables : Array

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if interactables.size() > 0:
			interactables[0].interact()

func _physics_process(delta):
	var input_vector = PlayerStatics.get_input_vector()
	move_and_slide(input_vector.normalized() * speed)

func _on_InteractionArea_area_entered(area : Interactable):
	interactables.push_back(area)

func _on_InteractionArea_area_exited(area : Interactable):
	var _ind = interactables.find(area)
	if _ind != -1:
		interactables.remove(_ind)
