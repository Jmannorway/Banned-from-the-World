extends VideoPlayer

export(PackedScene) var bedroom_scene

func _on_cutscene_finished():
	Util.goto_world(get_tree(), Game.WORLD.OUTER)
