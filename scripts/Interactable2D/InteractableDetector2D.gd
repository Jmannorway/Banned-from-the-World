extends Area2D

class_name InteractableDetector2D

var interactables : Array

# TODO: Make it so that 'facing' something isn't dependent on dot == -1
# This will make it more convenient to create doors spanning multiple squares
func interact_with_facing(pos : Vector2, facing : Vector2):
	facing = facing.normalized()
	for i in interactables:
		var _rel_pos = (pos - i.position).normalized()
		if facing.dot(_rel_pos) == -1:
			(i as Interactable2D).interact()
			break

func _on_interactable_detector_2d_area_shape_entered(area_rid, area : Interactable2D, area_shape_index, local_shape_index):
	if area:
		match local_shape_index:
			0:
				area.step()
			1:
				interactables.push_back(area)
	else:
		print("area was not of type Interactable2D")


func _on_interactable_detector_2d_area_shape_exited(area_rid, area : Interactable2D, area_shape_index, local_shape_index):
	if area && local_shape_index:
		var _index = interactables.find(area)
		interactables.remove(_index)
