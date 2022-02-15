extends Node

enum VIEWPORT_MODE {TWO_DIMENSIONAL, THREE_DIMENSIONAL}

var object : Object
var alpha_path : String
var fade_duration := 1.0
var visible := false
var map_name : String
const DEFAULT_FOCUS_SCENE_PATH_2D = "res://scenes/x to focus/focus_scenes/focus_placeholder_ghost.tscn"
var viewport_mode = VIEWPORT_MODE.TWO_DIMENSIONAL setget set_viewport_mode
onready var viewport := $viewport

signal focus
signal unfocus

func set_viewport_mode(val):
	match val:
		VIEWPORT_MODE.TWO_DIMENSIONAL:
			viewport.size = Game.RESOLUTION_2D
		VIEWPORT_MODE.THREE_DIMENSIONAL:
			viewport.size = Game.RESOLUTION_3D
	
	viewport_mode = val

func _ready():
	MapManager.connect("map_changed", self, "_on_MapManager_map_changed")
	set_faded_default_node()

func _on_MapManager_map_changed(new_map_name : String):
	if map_name != new_map_name:
		map_name = new_map_name
		
		var _scene_path : String
		var _2d : bool
		
		match map_name:
			"ghost_town_map":
				_scene_path = ""
				_2d = false
			_:
				_scene_path = DEFAULT_FOCUS_SCENE_PATH_2D
				_2d = true
		
		if !_scene_path.empty():
			if _2d: # if not is 2d then add it using the right function
				var _node2d = load(_scene_path).instance()
				set_faded_node2d(_node2d)
				set_viewport_mode(VIEWPORT_MODE.TWO_DIMENSIONAL)
			else: # if not is not 2d then assume it's a mesh instance
				var _spatial = load(_scene_path).instance()
				set_faded_mesh_instance(_spatial)
				set_viewport_mode(VIEWPORT_MODE.THREE_DIMENSIONAL)

func _process(delta):
	if Input.is_action_just_pressed("focus"):
		toggle_fade()

func reparent_node_to_self(node : Node):
	for c in viewport.get_children():
		c.call_deferred("queue_free")
	
	if node.get_parent():
		node.get_parent().call_deferred("remove_child", node)
	
	viewport.call_deferred("add_child", node)

func object_set_alpha(object : Object, color_path : String, val : float):
	var _col = object.get(color_path)
	object.set(color_path, Color(_col.r, _col.g, _col.b, val))

func set_faded_object(new_object : Object, new_color_path : String, mode):
	if new_object && !new_color_path.empty():
		object = new_object
		alpha_path = new_color_path + ":a"
		visible = false
		object_set_alpha(object, new_color_path, 0.0)
		set_viewport_mode(mode)
	else:
		print("X: Object or alpha path not valid")

func set_faded_node2d(node : Node2D):
	if node:
		reparent_node_to_self(node)
		set_faded_object(node, "modulate", VIEWPORT_MODE.TWO_DIMENSIONAL)

func set_faded_mesh_instance(mesh_instance : MeshInstance):
	if mesh_instance:
		reparent_node_to_self(mesh_instance)
		set_faded_object(mesh_instance.get_active_material(0), "albedo_color", VIEWPORT_MODE.THREE_DIMENSIONAL)

func set_faded_default_node():
	var _node = load(DEFAULT_FOCUS_SCENE_PATH_2D).instance()
	set_faded_node2d(_node)

func toggle_fade():
	var _a
	visible = !visible
	
	if visible:
		emit_signal("focus")
		_a = 1.0
	else:
		emit_signal("unfocus")
		_a = 0.0
	
	$visibility_tween.stop_all()
	$visibility_tween.interpolate_property(object, alpha_path, null, _a, fade_duration)
	$visibility_tween.start()
