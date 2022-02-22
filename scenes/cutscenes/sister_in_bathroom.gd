extends VideoPlayer

export(PackedScene) var bedroom_scene

func _on_cutscene_finished():
	get_tree().change_scene_to(bedroom_scene)
