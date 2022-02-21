extends Interactable

class_name InteractableWarp

export var changeToScene: PackedScene

# warning-ignore:unused_argument
func _interact(var roomManager) -> void:
# warning-ignore:return_value_discarded
#	get_tree().change_scene_to(changeToScene)
	
	MapManager.warp_to_map(changeToScene, 0)
