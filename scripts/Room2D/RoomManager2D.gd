extends Node2D

class_name RoomManager2D

var room_loaders : Dictionary
var room_layers : Array
var current_room_name : String setget set_current_room_name
func set_current_room_name(room_name : String):
	previous_room_name = current_room_name
	current_room_name = room_name
var previous_room_name : String
const ROOM_LOADER_GROUP_NAME = "room_loaders"

signal room_loaded(room_name, room_loader_node)
signal room_unloaded(room_name, room_loader_node)
signal room_focused(room_name, room_loader_node)

func _ready():
	room_layers.resize(WorldGrid.LAYER_COUNT)
	Util.connect_safe(MapManager, "changing_map", self, "_on_MapManager_MapChanged")

func _on_MapManager_MapChanged():
	room_loaders.clear()
	for i in room_layers.size():
		room_layers[i] = null
	if is_transitioning():
		stop_transition()

func register_room_loader(room : RoomLoader2D):
	room_loaders[room.room_name] = room

func register_room_layer(room_layer):
	room_layers[room_layer.layer] = room_layer

func get_room_loader_by_name(room_name : String) -> RoomLoader2D:
	return room_loaders.get(room_name)

func room_is_loaded(room_name : String) -> bool:
	return room_loaders.has(room_name)

func room_is_current(room_name : String) -> bool:
	return room_name == current_room_name

func get_current_room_loader() -> RoomLoader2D:
	return room_loaders.get(current_room_name)

func load_room(room_name : String) -> void:
	if room_loaders.has(room_name):
		room_loaders[room_name].call_deferred("set_loaded", true)
		emit_signal("room_loaded", room_name, room_loaders[room_name])
	else:
		print("MapManager2D: Current map doesn't contain a registered room called '", room_name, "'")

func unload_room(room_name : String) -> void:
	if room_loaders.has(room_name):
		room_loaders[room_name].call_deferred("set_loaded", false)
		emit_signal("room_unloaded", room_name, room_loaders[room_name])
	else:
		print("MapManager2D: Current map doesn't contain a registered room called '", room_name, "'")

func focus_room(room_name : String) -> void:
	if room_loaders.has(room_name):
		if !room_loaders[room_name].is_loaded():
			load_room(room_name)
			Util.connect_safe(room_loaders[room_name], "loaded", self, "_on_RoomLoader_loaded")
		else:
			emit_signal("room_focused", room_name, room_loaders[room_name])
		set_current_room_name(room_name)
	else:
		print("MapManager2D: Can't focus on non-existent room ", room_name);

func change_room(room_name : String) -> void:
	unload_room(current_room_name)
	focus_room(room_name)

# CALLBACKS
func _on_RoomLoader_loaded(room_loader):
	emit_signal("room_focused", current_room_name, room_loaders[current_room_name])
	var _player = PlayerAccess.get_player_2d(get_tree())
	if _player:
		Util.reparent_to(_player, MapManager.get_deepest_spawn_point(room_loader.room_name, _player.layer))

# ROOM TRANSITION FUNCTIONS
func smooth_transition_to_room(room_name : String, room_layer : int, keep := false, duration := 2.0) -> void:
	if is_transitioning() && previous_room_name != room_name:
		finish_transition()
	var _camera = Util.get_first_node_in_group(get_tree(), "camera")
	_camera.smooth_bounds = true
	_camera.smoothing_enabled = true
	focus_room(room_name)
	
	if keep:
		$room_unload_timer.start(duration)
	else:
		unload_room(previous_room_name)

func is_transitioning() -> bool:
	return !$room_unload_timer.is_stopped()

func finish_transition() -> void:
	$room_unload_timer.stop()
	unload_room(previous_room_name)

func stop_transition() -> void:
	$room_unload_timer.stop()

func _on_room_unload_timer_timeout():
	unload_room(previous_room_name)
