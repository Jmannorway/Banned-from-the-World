extends MenuController

signal activate_item(itemName)

func _ready():
	set_cursor_focus(currentX, currentY)
	
#	connect("activate_item", PlayerAccess.get_player_2d(get_tree()), "set_effect")

func receive_action(var action: int, var actionName: String) -> void:
	if action == ButtonAction.Action.DUMMY:
		emit_signal("activate_item", actionName)
		Ui.get_menu().pause(false)
		queue_free()

func _get_menu_buttons() -> void:
	if !menuButtonsPath.is_empty():
		var _menuButtonParent: Control = get_node(menuButtonsPath)
		var _menuList: Array
		
		for button in _menuButtonParent.get_children():
			if button is ButtonAction:
				button.connect("cancel", self, "remove_menu")
				button.connect("send_new_menu", self, "new_menu")
				button.connect("action", self, "receive_action")
				
				if Statistics.metadata["unlocked_effects"].has(button.actionName):
					button.set_active(Statistics.metadata["unlocked_effects"][button.actionName])
				
				_menuList.push_back(button)
			else:
				print("[SKIPPED] : ", button.name, " isn't of type Button.")
		
		menuItems.push_back(_menuList)
	else:
		print("[WARNING] : Cannot initialize ", name, ". No path set for the menu button list.")

func _override_input(var event) -> void:
	if Input.is_action_just_pressed("focus"):
		remove_menu()
	
	if menuItems.empty():
		return
	
	if Input.is_action_just_pressed("interact"):
		menuItems[currentX][currentY].send_action()
		return
	
	currentX += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	currentY += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	currentX = wrapi(currentX, 0, menuItems.size())
	currentY = wrapi(currentY, 0, menuItems[currentX].size())
	
	set_cursor_focus(currentX, currentY)

func set_cursor_focus(var x: int, var y: int) -> void:
	selector.rect_global_position = menuItems[x][y].rect_global_position - Vector2.ONE * 4
