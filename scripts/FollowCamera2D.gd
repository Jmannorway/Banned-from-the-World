extends Node2D

func _process(delta: float) -> void:
	var _camera = Util.get_first_node_in_group(get_tree(), "camera")
	if is_instance_valid(_camera):
		global_position = _camera.global_position
