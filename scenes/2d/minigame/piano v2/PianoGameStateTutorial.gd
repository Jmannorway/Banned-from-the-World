extends PianoGameState

var change_arrow : bool

func added():
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")
	Util.connect_safe(spawner, "changed_state", self, "_on_spawner_changed_state")
	spawner.spawn_bars = 1
	spawner.pause_bars = -1

func bar():
	if change_arrow:
		# rotate arrow based on the player's position
		arrow.set_direction(Game.DIR4.UP if randf() < 0.5 else Game.DIR4.DOWN)
		change_arrow = false

func _on_spawner_changed_state(state):
	if state == spawner.STATE.PAUSED:
		Ui.action_hint.show_action_hint(Ui.action_hint.HINT.X)
		change_arrow = true

func _on_XToFocus_focus_changed(focus):
	if !focus:
		spawner.queue_state(spawner.STATE.SPAWNING)
