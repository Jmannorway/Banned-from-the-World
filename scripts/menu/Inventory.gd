extends MenuController

func _get_menu_buttons() -> void:
	if !menuButtonsPath.is_empty():
		var _menuButtonParent: Control = get_node(menuButtonsPath)
		
		for row in _menuButtonParent.get_children():
			var _menuList: Array
			
			for button in row.get_children():
				if button is ButtonAction:
					button.connect("cancel", self, "remove_menu")
					button.connect("send_new_menu", self, "new_menu")
					
					_menuList.push_back(button)
				else:
					print("[SKIPPED] : ", button.name, " isn't of type Button.")
			
			menuItems.push_back(_menuList)
	else:
		print("[WARNING] : Cannot initialize ", name, ". No path set for the menu button list.")
	
	print(menuItems)

func _override_input(var event) -> void:
	if Input.is_action_just_pressed("focus"):
		remove_menu()
	
	if menuItems.empty():
		return
	
	if Input.is_action_just_pressed("interact"):
		menuItems[currentY][currentX].action()
		return
	
	currentX += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	currentY += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	currentY = wrapi(currentY, 0, menuItems.size())
	currentX = wrapi(currentX, 0, menuItems[currentY].size())
	
	print(currentX, ", ", currentY)
