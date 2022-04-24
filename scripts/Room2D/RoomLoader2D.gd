tool

extends Node2D

class_name RoomLoader2D

# TODO: Currently loading in this class refers to two fundamentally different things
# this needs to change to mitigate confusions in the future

export var room_name : String
export var room : PackedScene
var room_instance : Node

export var preview := false setget set_preview
func set_preview(val) -> void:
	if Engine.editor_hint:
		set_loaded(val)
		preview = loaded

# Size of the containing room. Used for camera and looping etc.
export var size := Vector2(480, 360) setget set_size
func set_size(val : Vector2) -> void:
	size = val
	update()

var loaded := false setget set_loaded
func set_loaded(val : bool) -> void:
	if val && !loaded:
		_load_room()
	elif !val && loaded:
		_unload_room()

#If true will automatically loop entities
#that move outside of the room bounds
export(bool) var looping setget set_looping
func set_looping(val : bool) -> void:
	if loaded && looping && !val:
		disconnect_looping_character_nodes()
	looping = val

signal loaded(room_loader)
signal unloaded(room_loader)

func connect_looping_character_nodes() -> void:
	for n in get_tree().get_nodes_in_group("characters"):
		make_character_looping(n)

func make_character_looping(character):
	Util.connect_safe(character, "move_started", self, "_on_Character_move_started", [character])

func disconnect_looping_character_nodes() -> void:
	for n in get_tree().get_nodes_in_group("characters"):
		n.disconnect("move_started", self, "_on_Character_move_started")

func wrap_node(node : Node2D):
	var _room = MapManager.get_room_manager().get_current_room_loader()
	node.global_position = Vector2(
		wrapi(node.global_position.x, global_position.x, global_position.x + size.x),
		wrapi(node.global_position.y, global_position.y, global_position.y + size.y))

func get_global_middle() -> Vector2:
	return global_position + size / 2.0

func is_loaded() -> bool:
	return loaded

# INTERNAL FUNCTIONS
func _enter_tree():
	if room_name.empty():
		room_name = name
	if !Engine.editor_hint:
		MapManager.get_room_manager().register_room_loader(self)

func _ready():
	Util.connect_safe(MapManager, "room_focused", self, "_on_MapManager_room_focused")
	$area/bounds.position = size / 2
	$area/bounds.shape.extents = size / 2

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(Vector2.ZERO, size), Color.white, false, 2.0)

func _load_room():
	room_instance = room.instance()
	add_child(room_instance)
	
	if looping:
		connect_looping_character_nodes()
	
	loaded = true
	emit_signal("loaded", self)

func _unload_room():
	if is_instance_valid(room_instance):
		room_instance.queue_free()
	room_instance = null
	
	if looping:
		disconnect_looping_character_nodes()
	
	clear_unwanted_children()
	
	loaded = false
	emit_signal("unloaded", self)

func clear_unwanted_children() -> void:
	var _childrenRooms: Array = get_children()
	
	for node in _childrenRooms:
		node.queue_free()

# Callbacks
func _on_Character_move_started(character_node):
	wrap_node(character_node)
