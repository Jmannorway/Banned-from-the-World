extends Control

class_name MenuController

export var selectorPath: NodePath
export var menuButtonsPath: NodePath

var menuItems: Array
var currentX: int
var currentY: int

var parentMenu: MenuController
var selector: Control

var active: bool = true

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	_get_menu_buttons()
	_get_selector()

func _get_selector() -> void:
	if selectorPath.is_empty():
		return
	
	selector = get_node(selectorPath)

func _input(event):
	if _ignore_input(event):
		return
	
	_override_input(event)

func _get_menu_buttons() -> void:
	if !menuButtonsPath.is_empty():
		var _menuButtonParent: Control = get_node(menuButtonsPath)
		var _menuList: Array
		
		for button in _menuButtonParent.get_children():
			if button is ButtonAction:
				button.connect("cancel", self, "remove_menu")
				button.connect("send_new_menu", self, "new_menu")
				
				_menuList.push_back(button)
			else:
				print("[SKIPPED] : ", button.name, " isn't of type Button.")
		
		menuItems.push_back(_menuList)
	else:
		print("[WARNING] : Cannot initialize ", name, ". No path set for the menu button list.")

func _ignore_input(var event) -> bool:
	return event is InputEventMouseMotion or event is InputEventJoypadMotion or event is InputEventJoypadButton or event is InputEventMouseButton

func _override_input(var event) -> void:
	if Input.is_action_just_pressed("menu"):
		remove_menu()
	
	if menuItems.empty():
		return
	
	if Input.is_action_just_pressed("interact"):
		menuItems[currentX][currentY].send_action()
		return
	
	currentX += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	currentY += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	currentX = wrapi(currentX, 0, menuItems.size())
	currentY = wrapi(currentY, 0, menuItems[currentX].size())
	
	set_cursor_focus(currentX, currentY)

func set_cursor_focus(var x: int, var y: int) -> void:
	selector.rect_position.y = menuItems[x][y].rect_position.y + 10

func remove_menu() -> void:
	if parentMenu == null:
		get_tree().quit()
		return
	
	parentMenu.set_active(true)
	
	queue_free()

func new_menu(var menu: PackedScene) -> void:
	if menu == null:
		return
	
	var _newMenu: MenuController = menu.instance()
	_newMenu.parentMenu = self
	
	get_parent().add_child(_newMenu)
	
	set_active(false)

func set_active(var status: bool) -> void:
	active = status
	set_process_input(status)
	visible = status
