extends Interactable2D

var touched := false

func _ready():
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")

func step():
	if !touched:
		var _player = PlayerAccess.get_player_2d(get_tree())
		_player.frozen.set_weight("minigame", true)
		$piano_game_cutscene.play("cutscene");
		touched = true

func _on_XToFocus_focus_changed(focus : bool):
	if focus:
		XToFocus.can_focus.set_weight("minigame", true)
		$piano_game_cutscene.play("cutscene part 2")
