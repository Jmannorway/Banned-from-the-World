extends ButtonAction

export (int, "Outer", "Inner")var sendToWorld

func send_action() -> void:
	# make sure we unpause... cause that's annoying when it doesn't
	emit_signal("action", 0, "resume")
	
	Temp.goto_world(get_tree(), sendToWorld)
