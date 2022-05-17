extends ButtonAction

export (int, "Outer", "Inner")var sendToWorld

func send_action() -> void:
	Temp.goto_world(get_tree(), sendToWorld)
