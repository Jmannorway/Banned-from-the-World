extends Node

enum VIEWPORT_MODE {TWO_DIMENSIONAL, THREE_DIMENSIONAL}

const PHASE_FOCUS_SCENES = {
	PHASE_ONE = "",		# bedroom
	PHASE_TWO = "res://scenes/x to focus/focus_scenes/focus_placeholder_ghost.tscn", # mazes
	PHASE_THREE = "",	# exploration
	PHASE_FOUR = ""		# minigame
}

var fade_duration := 1.0
var visible := false
var viewport_mode = VIEWPORT_MODE.TWO_DIMENSIONAL setget set_viewport_mode
var overridden := false

signal focus
signal unfocus

func override(node : Node, mode):
	set_faded_node(node)
	set_viewport_mode(mode)
	overridden = true

func set_viewport_mode(val):
	match val:
		VIEWPORT_MODE.TWO_DIMENSIONAL:
			$viewport.size = Game.RESOLUTION_2D
		VIEWPORT_MODE.THREE_DIMENSIONAL:
			$viewport.size = Game.RESOLUTION_3D
	
	viewport_mode = val

func set_faded_node(node : Node):
	Util.reparent_to(node, $viewport)
	$viewport_sprite.modulate.a = 0.0
	visible = false

func set_faded_default_node():
	set_faded_node(load(PHASE_FOCUS_SCENES.PHASE_TWO).instance())
	set_viewport_mode(VIEWPORT_MODE.TWO_DIMENSIONAL)

func set_faded_default_node_map(new_map_name):
	var _scene_path : String
	var _mode = VIEWPORT_MODE.TWO_DIMENSIONAL
	
	match new_map_name:
		_:
			_scene_path = PHASE_FOCUS_SCENES.PHASE_TWO
	
	if !_scene_path.empty():
		set_faded_node(load(_scene_path).instance())
	set_viewport_mode(_mode)

func toggle_fade():
	var _a
	visible = !visible
	
	if visible:
		emit_signal("focus")
		_a = 1.0
	else:
		emit_signal("unfocus")
		_a = 0.0
	
	$visibility_tween.remove_all()
	$visibility_tween.interpolate_property($viewport_sprite, "modulate:a", null, _a, fade_duration)
	$visibility_tween.start()

func set_default_if_not_overridden(map_name := ""):
	if !overridden:
		if map_name.empty():
			set_faded_default_node()
		else:
			set_faded_default_node_map(map_name)
	else:
		overridden = false

func _ready():
	MapManager.connect("map_changed", self, "_on_MapManager_map_changed")

func _process(delta):
	if Input.is_action_just_pressed("focus"):
		toggle_fade()

func _on_MapManager_map_changed(new_map_name : String):
	set_default_if_not_overridden(new_map_name)
