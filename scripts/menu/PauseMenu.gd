extends MenuController

var inAnotherMenu: bool

func _ready():
	set_active(false)

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
		pause(false)

func pause(var status: bool) -> void:
	get_tree().paused = status
	set_active(get_tree().paused)

func _override_input(var event) -> void:
	if Input.is_action_just_pressed("menu") and !inAnotherMenu:
		pause(!get_tree().paused)
		
		currentX = 0
		currentY = 0
		
		set_cursor_focus(currentX, currentY)
	
	if !active:
		return
	
	._override_input(event)

func remove_menu() -> void:
	pass

func new_menu(var menuScene: PackedScene) -> void:
	inAnotherMenu = true
	
	.new_menu(menuScene)

func set_active(var status: bool) -> void:
	inAnotherMenu = inAnotherMenu && !status
	
	active = status
#	set_process_input(status)
	visible = status
