extends Node2D

class_name MapManager2D

var current_map : PackedScene
var current_map_name : String
var current_map_instance : Node

var rooms : Dictionary
const MAP_DIRECTORY = "res://scenes/2d/maps/"
const ROOM_GROUP_NAME = "rooms"

func collect_rooms() -> void:
	rooms.clear()
	var room_group = get_tree().get_nodes_in_group(ROOM_GROUP_NAME)
	for r in room_group:
		rooms[r.room_name] = r

func get_room_by_name(room_name : String) -> Room2D:
	return rooms[room_name]

func change_map(map_name : String) -> void:
	if current_map_instance:
		current_map_instance.call_deferred("queue_free")
	
	current_map = load(MAP_DIRECTORY + map_name + ".tscn")
	
	if current_map:
		current_map_instance = current_map.instance()
		add_child(current_map_instance)
		current_map_name = map_name
		collect_rooms()
	else:
		current_map_instance = null
		current_map_name = ""
		print("MapManager2D: Invalid map name couldn't load")
