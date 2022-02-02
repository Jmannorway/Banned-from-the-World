extends Node2D

class_name RoomManager2D

var room_loaders : Dictionary
var current_room_name : String
const ROOM_LOADER_GROUP_NAME = "room_loaders"

signal room_loaded(room_name)
signal room_unloaded(room_name)

func _ready():
	MapManager.connect("map_changed", self, "_on_MapManager_MapChanged")
	collect_rooms()

func _on_MapManager_MapChanged():
	collect_rooms()

func get_room_by_name(room_name : String) -> RoomLoader2D:
	return room_loaders.get(room_name)

func room_is_loaded(room_name : String) -> bool:
	return room_loaders.has(room_name)

func room_is_current(room_name : String) -> bool:
	return room_name == current_room_name

func load_room(room_name : String) -> void:
	if room_loaders.has(room_name):
		current_room_name = room_name
		room_loaders[room_name].call_deferred("set_loaded", true)
	else:
		print("MapManager2D: Current map doesn't contain a registered room called '", room_name, "'")

func unload_room(room_name : String) -> void:
	if room_loaders.has(room_name):
		room_loaders[room_name].call_deferred("set_loaded", false)
	else:
		print("MapManager2D: Current map doesn't contain a registered room called '", room_name, "'")

func change_room(room_name : String) -> void:
	unload_room(current_room_name)
	load_room(room_name)

func collect_rooms() -> void:
	room_loaders.clear()
	var room_group = get_tree().get_nodes_in_group(ROOM_LOADER_GROUP_NAME)
	for r in room_group:
		room_loaders[r.room_name] = r
