extends Control

class_name MenuController

export var menuButtonsPath: NodePath

var menuItems: Array
var currentX: int
var currentY: int

var parentMenu: MenuController

onready var selector: Control = $selector_margin

func _ready():
	_get_menu_buttons()

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
	if Input.is_action_just_pressed("focus"):
		remove_menu()
	
	if menuItems.empty():
		return
	
	if Input.is_action_just_pressed("interact"):
		menuItems[currentX][currentY].action()
		return
	
	currentX += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	currentY += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	currentX = wrapi(currentX, 0, menuItems.size())
	currentY = wrapi(currentY, 0, menuItems[currentX].size())
	
	selector.rect_position.y = menuItems[currentX][currentY].rect_position.y + 10

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
	set_process_input(status)
	visible = status
