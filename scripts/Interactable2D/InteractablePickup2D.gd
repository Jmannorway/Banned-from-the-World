extends Interactable2D

export(String) var effect

func update_visibility() -> void:
	visible = !Statistics.metadata.unlocked_effects[effect]

func _ready() -> void:
	update_visibility()

func step():
	pass

func interact():
	if !Statistics.metadata.unlocked_effects[effect]:
		Statistics.metadata.unlocked_effects[effect] = true
		# function visibly unlocking the effect
		update_visibility()
		
		var _effect_notifier = Ui.get_effect_notifier()
		Util.connect_safe(_effect_notifier, "notification_dismissed", self, "_on_effect_notifier_notification_dismissed")
		_effect_notifier.show_notification(effect)
		
		PlayerAccess.get_player_2d(get_tree()).set_frozen(name, true)
		Statistics.write_meta_file()

func _on_effect_notifier_notification_dismissed():
	PlayerAccess.get_player_2d(get_tree()).set_frozen(name, false)
