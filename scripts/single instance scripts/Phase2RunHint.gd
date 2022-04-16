extends Interactable2D

func step():
	if (Statistics.metadata["inner_world_travel_count"] <= 1):
		Ui.get_action_hint().show_action_hint(Ui.get_action_hint().HINT.SHIFT, 0.0, true)
		queue_free()

func interact():
	pass
