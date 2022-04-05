extends Interactable

export(PackedScene) var win_scene

func _on_Area_area_entered(area):
	get_tree().change_scene_to(win_scene)
