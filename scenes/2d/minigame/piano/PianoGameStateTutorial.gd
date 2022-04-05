extends PianoGameState

var change_arrow : bool

func get_player_z() -> float:
	var _player = PlayerAccess.get_player_3d(get_tree())
	if _player:
		return _player.get_integer_position().z
	return 0.0

func added():
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")
	Util.connect_safe(spawner, "changed_state", self, "_on_spawner_changed_state")
	spawner.spawn_bars = 1
	spawner.pause_bars = 2

func bar():
	if change_arrow:
		var z = get_player_z()
		print(z)
		if z < 0.0:
			arrow.set_direction(Game.DIR4.LEFT if randf() < 0.5 else Game.DIR4.RIGHT)
			spawner.ghost_direction = -1
		elif z < 2.0:
			arrow.set_direction(Game.DIR4.DOWN)
			spawner.ghost_direction = Game.DIR4.DOWN
		elif z < 4.0:
			arrow.set_direction(Game.DIR4.UP)
			spawner.ghost_direction = -1
		
		change_arrow = false

func _on_spawner_changed_state(state):
	if state == spawner.STATE.PAUSED:
		change_arrow = true
func _on_XToFocus_focus_changed(focus):
	if !focus && spawner.pause_bars == -1:
		spawner.queue_state(spawner.STATE.SPAWNING)
