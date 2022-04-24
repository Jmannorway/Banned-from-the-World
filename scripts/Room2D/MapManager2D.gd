extends Node2D

class_name MapManager2D

var current_map : PackedScene
var current_map_name : String
var current_map_instance : Node
onready var viewport = $game_viewport
onready var viewport_sprite = $game_viewport_sprite
onready var transition_manager = $transition_layer/transition_manager
const MAP_DIRECTORY = "res://scenes/2d/maps/"

const INVALID_PLAYER_START_INDEX := -1
var player_start_index := 0

signal map_changed(map_name)
signal changing_map()

func _ready():
	viewport.set_mode(viewport.MODE.TWO_DIMENSIONAL)
	
	if !current_map_instance:
		current_map_instance = get_tree().current_scene

func has_map() -> bool:
	return is_instance_valid(current_map_instance)

func get_room_manager() -> RoomManager2D:
	return $room_manager_2d as RoomManager2D

func transition_to_map_by_path(map_path : String, psi = 0) -> void:
	transition_manager.play_transition()
	yield(transition_manager, "transition_middle")
	warp_to_map_by_path(map_path, psi)

func warp_to_map(map_scene : PackedScene, psi = 0) -> void:
	player_start_index = psi
	change_map(map_scene)
	emit_signal("changing_map")

func warp_to_map_by_name(map_name : String, psi = 0) -> void:
	player_start_index = psi
	change_map_by_name(map_name)
	emit_signal("changing_map")

func warp_to_map_by_path(map_path : String, psi = 0) -> void:
	player_start_index = psi
	change_map_by_path(map_path)
	emit_signal("changing_map")

func clear_map() -> void:
	if is_instance_valid(current_map_instance):
		current_map_instance.queue_free()

func reset_player_start_index() -> void:
	player_start_index = INVALID_PLAYER_START_INDEX

func set_map_instance_child(map_inst : Map2D) -> void:
	Util.reparent_to_deferred(map_inst, viewport)
	current_map_instance = map_inst
	current_map_name = map_inst.name
	emit_signal("map_changed", current_map_name)

func change_map(map_scene : PackedScene) -> void:
	if is_instance_valid(current_map_instance):
		current_map_instance.queue_free()
		current_map_instance = null
	
	current_map = map_scene
	
	if current_map:
		set_map_instance_child(map_scene.instance())
	else:
		current_map_instance = null
		print("MapManager2D: Invalid map scene couldn't instance")

func change_map_by_name(map_name : String) -> void:
	var _map = load(MAP_DIRECTORY + map_name + ".tscn")
	if _map:
		current_map_name = map_name
		change_map(_map)
	else:
		print("MapManager2D: Invlid map name couldn't load: ", map_name)

func change_map_by_path(map_path : String) -> void:
	var _map = load(map_path)
	if _map:
		current_map_name = Util.get_filename_from_path(map_path)
		change_map(_map)
	else:
		print("MapManager2D: Invalid map path, couldn't load from: ", map_path)

static func get_deepest_spawn_point(room_name : String, room_layer : int) -> Node:
	if MapManager.has_map():
		var _room_manager = MapManager.get_room_manager()
		if _room_manager.room_loaders.has(room_name):
			if _room_manager.room_layers[room_layer]:
				print("RoomManager2D: Found room layer ", room_layer)
				return _room_manager.room_layers[room_layer]
			elif _room_manager.room_loaders[room_name].is_loaded():
				print("RoomManager2D: Room didn't have layer ", room_layer, ". Returning room")
				return _room_manager.room_loaders[room_name].room_instance
			else:
				print("RoomManager2D: Room '", room_name, "' wasn't loaded. Returning room loader")
				return _room_manager.room_loaders[room_name]
		else:
			printerr("RoomManager2D: RoomLoader '", room_name, "' not found. Returning current map")
			return MapManager.current_map_instance
	else:
		printerr("RoomManager2D: Map not found. Returning self")
		return MapManager

# CALLBACKS

func _on_transition_manager_transition_middle() -> void:
	pass # Replace with function body.
