extends Spatial

func _ready():
	if Statistics.metadata["inner_world_travel_count"] == 0 && !XToFocus.is_in_focus(self):
		var _player := PlayerAccess.get_player_3d(get_tree())
		if _player:
			_player.canMove = false
			Ui.get_action_hint().show_action_hint(Ui.get_action_hint().HINT.X)
