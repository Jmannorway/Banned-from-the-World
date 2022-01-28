extends Area2D

class_name InteractableDetector2D

var interactables : Array

func interact_with_facing(pos : Vector2, facing : Vector2):
	facing = facing.normalized()
	for i in interactables:
		var _inter_pos = (pos - i.position).normalized()
		if facing.dot(_inter_pos) == -1:
			(i as Interactable2D).interact()
			break

func _on_interactable_detector_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	area = area as Interactable2D
	match local_shape_index:
		0:
			area.step()
		1:
			interactables.push_back(area)


func _on_interactable_detector_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	area = area as Interactable2D
	match local_shape_index:
		1:
			var _index = interactables.find(area)
			interactables.remove(_index)
