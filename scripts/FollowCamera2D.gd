extends Node2D

var _camera

func _ready() -> void:
	_camera = Util.get_first_node_in_group(get_tree(), "camera")
	set_process(is_instance_valid(_camera))

func _process(delta : float) -> void:
	global_position = _camera.global_position
