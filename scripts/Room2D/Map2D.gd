extends Node

class_name Map2D

func reparent_to_map_manager():
	get_parent().call_deferred("remove_child", self)
	MapManager.set_map_instance_child(self)

func is_child_of_map_manager() -> bool:
	return get_parent() == MapManager

func _ready():
	if is_child_of_map_manager():
		reparent_to_map_manager()
