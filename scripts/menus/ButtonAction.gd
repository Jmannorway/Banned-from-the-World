extends Control

export (int, "Change Scene", "New Menu", "Change Option", "Cancel", "Quit")var action: int
export var actionName: String

class_name ButtonAction

signal action(actionType, actionName)
signal send_new_menu(newMenu)
signal cancel()

func action() -> void:
	match action:
		Action.CHANGE_SCENE:
			var _fullPath: String = "res://scenes/" + actionName + ".tscn"
			var _scene: PackedScene = load(_fullPath)
			
			if _scene == null:
				printerr("[ERROR] : \"", _fullPath, "\" scene does not exist. (Path may not be correct)")
				return
			
			get_tree().change_scene_to(_scene)
		Action.NEW_MENU:
			var _fullPath: String = "res://scenes/menus/" + actionName + ".tscn"
			var _menu: PackedScene = load(_fullPath)
			
			if _menu == null:
				printerr("[ERROR] : \"", _fullPath, "\" menu does not exist. (Path may not be correct)")
				return
			
			emit_signal("send_new_menu", _menu)
		Action.CHANGE_OPTION:
			print("Option: ", actionName)
		Action.CANCEL:
			emit_signal("cancel")
		Action.QUIT:
			get_tree().quit()
	
	emit_signal("action", action, actionName)

enum Action {
	CHANGE_SCENE,
	NEW_MENU,
	CHANGE_OPTION,
	CANCEL,
	QUIT
}
