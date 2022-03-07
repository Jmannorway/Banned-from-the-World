extends ItemList

# TODO: Find a good place to store important scenes

func _ready():
	visible = false

func _on_inner_world_menu_item_activated(index):
	match index:
		0:
			Ui.set_in_menu(false)
		1:
			Util.goto_world(get_tree(), Game.WORLD.INNER)
		2:
			Util.goto_world(get_tree(), Game.WORLD.OUTER)

func _on_inner_world_menu_visibility_changed():
	if visible:
		grab_focus()
