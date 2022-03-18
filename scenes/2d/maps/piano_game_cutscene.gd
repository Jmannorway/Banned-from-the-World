extends AnimationPlayer

func _ready():
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")

func tutorial_hint():
	Ui.action_hint.show_action_hint(Ui.action_hint.HINT.X)

func _on_XToFocus_focus_changed(focus):
	if !focus:
		play("cutscene part 2")
