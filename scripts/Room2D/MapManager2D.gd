extends Node2D

class_name MapManager2D

var current_map : PackedScene
var current_map_name : String
var current_map_instance : Node
const MAP_DIRECTORY = "res://scenes/2d/maps/"

const INVALID_PLAYER_START_INDEX := -1
var player_start_index := 0

signal map_changed(map_name)
signal changing_map()

func _ready():
	if !current_map_instance:
		current_map_instance = get_tree().current_scene

func get_room_manager() -> RoomManager2D:
	return $room_manager_2d as RoomManager2D

func warp_to_map(map_scene : PackedScene, psi = 0) -> void:
	player_start_index = psi
	call_deferred("change_map", map_scene)
	emit_signal("changing_map")

func warp_to_map_by_name(map_name : String, psi = 0) -> void:
	player_start_index = psi
	call_deferred("change_map_by_name", map_name)
	emit_signal("changing_map")

func warp_to_map_by_path(map_path : String, psi = 0) -> void:
	player_start_index = psi
	call_deferred("change_map_by_path", map_path)
	emit_signal("changing_map")

func reset_player_start_index() -> void:
	player_start_index = INVALID_PLAYER_START_INDEX

func change_map(map_scene : PackedScene) -> void:
	if current_map_instance:
		current_map_instance.call_deferred("queue_free")
		current_map_instance = null
	
	current_map = map_scene
	
	if current_map:
		current_map_instance = current_map.instance()
		add_child(current_map_instance)
		emit_signal("map_changed")
	else:
		current_map_instance = null
		print("MapManager2D: Invalid map scene couldn't instance")

func change_map_by_name(map_name : String) -> void:
	var _map = load(MAP_DIRECTORY + map_name + ".tscn")
	if _map:
		current_map_name = map_name
		change_map(_map)
	else:
		print("MapManager2D: Invlid map name couldn't load ", map_name)

func change_map_by_path(map_path : String) -> void:
	var _map = load(map_path)
	if _map:
		current_map_name = Util.get_filename_from_path(map_path)
		call_deferred("change_map", _map)
	else:
		print("MapManager2D: Invalid map path, couldn't load from: ", map_path)
