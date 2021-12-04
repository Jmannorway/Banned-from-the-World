extends Area2D

var interactables : Array

func interact_with_facing(pos : Vector2, look : Vector2):
	for i in interactables.size():
		interactables[i].interact()
		break

func _on_interactable_detector_area_entered(area : Interactable2D):
	interactables.push_back(area)

func _on_interactable_detector_area_exited(area : Interactable2D):
	var _index = interactables.find(area)
	if interactables.size() > _index:
		interactables.remove(_index)
