extends PianoGameState

var change_arrow : bool

func added():
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")
	Util.connect_safe(spawner, "changed_state", self, "_on_spawner_changed_state")
	spawner.spawn_bars = 1
	spawner.pause_bars = 1

func bar():
	if change_arrow:
		arrow.set_random_direction()
		change_arrow = false

func _on_spawner_changed_state(state):
	if state == spawner.STATE.PAUSED:
		change_arrow = true

func _on_XToFocus_focus_changed(focus):
	if !focus:
		spawner.queue_state(spawner.STATE.SPAWNING)
