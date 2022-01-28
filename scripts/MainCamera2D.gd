extends Camera2D

export var target_group : String
var target : Player2D
export var area : Rect2

func _process(delta):
	if is_instance_valid(target):
		offset = target.get_animated_position()
	else:
		target = Util.get_first_node_in_group(get_tree(), target_group)
