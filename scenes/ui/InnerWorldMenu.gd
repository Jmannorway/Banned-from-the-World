extends ItemList

var toggleable := WeightedBool.new()

func set_visible(val : bool):
	.set_visible(val)
	if visible:
		grab_focus()

func _ready():
	set_visible(false)
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")

func _input(event):
	if event.is_action_pressed("menu") && !toggleable.is_weighted():
		set_visible(!visible)

func _on_XToFocus_focus_changed(focus):
	toggleable.set_weight(XToFocus.name, focus)

func _on_inner_world_menu_item_activated(index):
	match index:
		0:
			Ui.set_in_menu(false)
		1:
			Util.goto_world(get_tree(), Game.WORLD.INNER)
		2:
			Util.goto_world(get_tree(), Game.WORLD.OUTER)
