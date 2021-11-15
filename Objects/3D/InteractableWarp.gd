extends Interactable

const ROOM_DIRECTORY := "res://Levels/"
const ROOM_POSTFIX := ".tscn"
export var room : String

func get_room_path(room_name : String) -> String:
	return ROOM_DIRECTORY + room + ROOM_POSTFIX

func interact() -> void:
	get_tree().change_scene(get_room_path(room))
