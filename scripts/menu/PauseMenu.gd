extends MenuController

func _get_menu_buttons() -> void:
	if !menuButtonsPath.is_empty():
		var _menuButtonParent: Control = get_node(menuButtonsPath)
		var _menuList: Array
		
		for button in _menuButtonParent.get_children():
			if button is ButtonAction:
				button.connect("cancel", self, "remove_menu")
				button.connect("send_new_menu", self, "new_menu")
				button.connect("action", self, "custom_actions_menu")
				
				_menuList.push_back(button)
			else:
				print("[SKIPPED] : ", button.name, " isn't of type Button.")
		
		menuItems.push_back(_menuList)
	else:
		print("[WARNING] : Cannot initialize ", name, ". No path set for the menu button list.")

func custom_actions_menu(var action: int, var actionName: String) -> void:
	if actionName == "resume":
		print("resume to game")
