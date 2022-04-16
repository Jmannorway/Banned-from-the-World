extends AnimationPlayer

func tutorial_hint():
	Ui.get_action_hint().show_action_hint(Ui.get_action_hint().HINT.X)

func start_minigame():
	var _minigame = Util.get_first_node_in_group(get_tree(), "minigame")
	_minigame.start()
	_minigame.get_parent().visible = true

func fade_in_minigame(duration : float):
	var _minigame = Util.get_first_node_in_group(get_tree(), "minigame")
	$tween.interpolate_property(_minigame.get_parent(), "modulate:a", null, 1.0, duration)
	$tween.start()
