extends Area2D

class_name InteractableDetector2D

enum LOCAL_SHAPE_TYPE {STEP, INTERACT}

var interactables : Array
export(NodePath) var owner_path 

signal stepped_on
signal detected

func _enter_tree():
	if owner_path.is_empty():
		set_owner(get_parent())
	else:
		set_owner(get_node(owner_path))

# TODO: Make it so that 'facing' something isn't dependent on dot == -1
# This will make it more convenient to create doors spanning multiple squares
func interact_with_facing(checking_node : Node2D, facing : Vector2) -> void:
	var _facing_interactable = get_facing_interactable(checking_node, facing)
	if _facing_interactable:
		_facing_interactable.interact()
	else:
		printerr("no facing interactable")

func get_facing_interactable(checking_node : Node2D, facing : Vector2) -> Interactable2D:
	var _pos = checking_node.global_position
	for i in interactables:
		var _dir = (_pos - i.global_position).normalized()
		if facing.dot(_dir) == -1:
			return i as Interactable2D
	return null

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_interactable_detector_2d_area_shape_entered(area_rid, area : Interactable2D, area_shape_index, local_shape_index):
	if area:
		match local_shape_index:
			LOCAL_SHAPE_TYPE.STEP:
				area.step()
			LOCAL_SHAPE_TYPE.INTERACT:
				interactables.push_back(area)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_interactable_detector_2d_area_shape_exited(area_rid, area : Interactable2D, area_shape_index, local_shape_index):
	if area && local_shape_index == LOCAL_SHAPE_TYPE.INTERACT:
		var _index = interactables.find(area)
		interactables.remove(_index)
