extends Interactable

class_name InteractableWarp

export var changeToScene: PackedScene

# warning-ignore:unused_argument
func _event(var player: CharacterController3D) -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(changeToScene)
