extends Node

# When adding 3d focus nodes you have to link the material
# that has the color property that you want animated using
# add_focus_object
# For bigger scenes it might be better to add the entire scene
# to the viewport using add_focus_scene. Although, adding a whole
# scene will only let you overlay it. Keep in mind that 3d scenes
# need a camera for them to work in the viewport.
# And don't forget to use a world environment with a transparent
# clear color unless you intend to flush the entire screen

class ObjectColorPathPair:
	var object : Object
	var color_path : String
	func _init(obj : Object, col_pth : String):
		object = obj
		color_path = col_pth

signal focus_changed(new_focus)

const DEFAULT_LAYER_INDEX = 5
var object_alpha_pairs : Dictionary
var alpha := 0.0
var focus := false
var fade_duration := 1.0
onready var viewport := $game_viewport
onready var viewport_sprite := $canvas_layer/game_viewport_sprite

func set_focus_shader(material : ShaderMaterial):
	viewport_sprite.material = material

func set_focus_shader_params(params : Dictionary):
	for key in params.keys():
		viewport_sprite.material.set_shader_param(key, params[key])

func set_focus_scene_position(position : Vector2):
	viewport_sprite.position = position

func set_focus_scene_layer(layer : int):
	$canvas_layer.layer = layer

func set_default_focus_scene():
	reset()
	$default_focus_scene.update()

func pass_player_position(val : bool):
	viewport_sprite.pass_player_position = val

# Removes all-focus affected nodes and scenes
func reset():
	set_focus_scene_layer(DEFAULT_LAYER_INDEX)
	set_focus_scene_position(Vector2.ZERO)
	clear_focus_nodes_and_objects()
	clear_focus_scenes()

func clear_focus_nodes_and_objects():
	object_alpha_pairs.clear()

func clear_focus_scenes():
	for _node in viewport.get_children():
		_node.queue_free()

func is_in_focus(node : Node) -> bool:
	return is_a_parent_of(node)

# Adds a node to have its alpha value changed along with focus
func add_focus_node(node : Node, color_path : String):
	if node && node.get(color_path) && typeof(node.get(color_path)) == TYPE_COLOR:
		object_alpha_pairs[node] = ObjectColorPathPair.new(node as Object, color_path)
# warning-ignore:return_value_discarded
		node.connect("tree_exiting", self, "_on_FocusNode_tree_exiting", [node])
		return true
	
	diagnose_node_color_path_pair(node, color_path)
	return false

# Adds an object to have its alpha value changed along with focus
# A limitation of this system is that any node can only have 1 focus object
func add_focus_object(owning_node : Node, object : Object, color_path : String):
	if owning_node && object && object.get(color_path) != null && typeof(object.get(color_path)) == TYPE_COLOR:
		object_alpha_pairs[owning_node] = ObjectColorPathPair.new(object, color_path)
# warning-ignore:return_value_discarded
		owning_node.connect("tree_exiting", self, "_on_FocusNode_tree_exiting", [owning_node])
		return true
	
	diagnose_node_color_path_pair(owning_node, color_path)
	if !object: print("XToFocus: Object was invalid")
	return false

func add_focus_scene(scene : PackedScene, is_2d : bool):
	var _node = scene.instance()
	viewport.call_deferred("add_child", _node)
	
	if is_2d:
		viewport.set_mode(viewport.MODE.TWO_DIMENSIONAL)
		viewport_sprite.set_mode(true)
	else:
		viewport.set_mode(viewport.MODE.THREE_DIMENSIONAL)
		viewport_sprite.set_mode(false)

func diagnose_node_color_path_pair(node : Node, color_path : String):
	if !node:
		print("XToFocus: Node was invalid")
	elif node.get(color_path) == null:
		print("XToFocus: Color path was invalid")
	elif typeof(node.get(color_path)) != TYPE_COLOR:
		print("XToFocus: Color path was not of type color")

# Tweens the value used for setting the alpha of focus nodes and viewport sprite
func toggle_focus():
	focus = !focus
	var _new_alpha = 1.0 if focus else 0.0
	emit_signal("focus_changed", focus)
	
	if $alpha_tween.is_active():
		$alpha_tween.playback_speed *= -1.0
	else:
		$alpha_tween.remove_all()
		$alpha_tween.interpolate_property(self, "alpha", null, _new_alpha, fade_duration)
		$alpha_tween.start()

func _ready():
# warning-ignore:return_value_discarded
	MapManager.connect("map_changed", self, "_on_MapManager_map_changed")

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("focus") && !Ui.in_menu:
		toggle_focus()

# warning-ignore:unused_argument
func _process(delta):
	for _key in object_alpha_pairs:
		Util.object_set_alpha(object_alpha_pairs[_key].object, object_alpha_pairs[_key].color_path, alpha)
	
	viewport_sprite.modulate.a = alpha

# warning-ignore:unused_argument
func _on_MapManager_map_changed(map_name):
	set_default_focus_scene()

func _on_FocusNode_tree_exiting(node):
# warning-ignore:return_value_discarded
	object_alpha_pairs.erase(node)

func enable_input(var status: bool) -> void:
	set_process_input(status)
