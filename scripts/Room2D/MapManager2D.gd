extends Node2D

class_name MapManager2D

var current_map : PackedScene
var current_map_instance : Node

const INVALID_PLAYER_START_INDEX := -1
var player_start_index := 0

var room_loaders : Dictionary
const MAP_DIRECTORY = "res://scenes/2d/maps/"
const ROOM_LOADER_GROUP_NAME = "room_loaders"

func _ready():
	if !current_map_instance:
		current_map_instance = get_tree().current_scene
	
	collect_rooms()

func warp_to_map(map_scene : PackedScene, psi = 0) -> void:
	player_start_index = psi
	change_map(map_scene)

func load_room(room_loader_name : String) -> void:
	if room_loaders.has(room_loader_name):
		room_loaders[room_loader_name].set_loaded(true)
	else:
		print("MapManager2D: Doesn't have room named '" + room_loader_name + "'")

func unload_room(room_loader_name : String) -> void:
	if room_loaders.has(room_loader_name):
		room_loaders[room_loader_name].set_loaded(false)

func collect_rooms() -> void:
	room_loaders.clear()
	var room_group = get_tree().get_nodes_in_group(ROOM_LOADER_GROUP_NAME)
	for r in room_group:
		room_loaders[r.room_name] = r
		connect("loaded", r, "_on_RoomLoader_Loaded")

func _on_RoomLoader_Loaded():
	print("yeah")

func reset_player_start_index() -> void:
	player_start_index = INVALID_PLAYER_START_INDEX

func get_room_loader_by_name(room_name : String) -> RoomLoader2D:
	return room_loaders[room_name]

func change_map(map_scene : PackedScene) -> void:
	if current_map_instance:
		current_map_instance.call_deferred("queue_free")
		current_map_instance = null
	
	current_map = map_scene
	
	if current_map:
		current_map_instance = current_map.instance()
		add_child(current_map_instance)
		collect_rooms()
	else:
		current_map_instance = null
		print("MapManager2D: Invalid map scene couldn't instance")

func change_map_by_name(map_name : String) -> void:
	var _map = load(MAP_DIRECTORY + map_name + ".tscn")
	if _map:
		change_map(_map)
	else:
		print("MapManager2D: Invlid map name couldn't load")
