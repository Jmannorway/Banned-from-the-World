extends ButtonAction

func send_action() -> void:
	if !active:
		return
	
	emit_signal("action", action, actionName)

func set_active(var status: bool) -> void:
	active = status
	$margin.visible = status
