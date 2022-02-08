extends Node

class ObjectColorPathPair:
	var object : Object
	var color_path : String
	func _init(obj : Object, col_pth : String):
		object = obj
		color_path = col_pth

signal focus_changed(new_focus)

var object_alpha_pairs : Dictionary
var alpha := 0.0
var focus := false
var fade_duration := 1.0

# Removes all-focus affected nodes
func clear_all():
	object_alpha_pairs.clear()

# Adds a node to have its alpha value changed along with focus
func add_focus_node(node : Node, color_path : String):
	if node && node.get(color_path) && typeof(node.get(color_path)) == TYPE_COLOR:
		object_alpha_pairs[node] = ObjectColorPathPair.new(node as Object, color_path)
		node.connect("tree_exiting", self, "_on_FocusNode_tree_exiting", [node])
		return true
	
	diagnose_node_color_path_pair(node, color_path)
	return false

func diagnose_node_color_path_pair(node : Node, color_path : String):
	if !node:
		print("XToFocus: Node was invalid")
	elif node.get(color_path) == null:
		print("XToFocus: Color path was invalid")
	elif typeof(node.get(color_path)) != TYPE_COLOR:
		print("XToFocus: Color path was not of type color")

# Adds an object to have its alpha value changed along with focus
# A limitation of this system is that any node can only have 1 focus object
func add_focus_object(owning_node : Node, object : Object, color_path : String):
	if owning_node && object && object.get(color_path) != null && typeof(object.get(color_path)) == TYPE_COLOR:
		object_alpha_pairs[owning_node] = ObjectColorPathPair.new(object, color_path)
		owning_node.connect("tree_exiting", self, "_on_FocusNode_tree_exiting", [owning_node])
		return true
	
	diagnose_node_color_path_pair(owning_node, color_path)
	if !object: print("XToFocus: Object was invalid")
	return false

# Tweens the value used for setting the alpha of focus nodes and viewport sprite
func toggle_focus():
	focus = !focus
	var _new_alpha = 1.0 if focus else 0.0
	emit_signal("focus_changed", focus)
	
	if $alpha_tween.is_active():
		$alpha_tween.playback_speed *= -1.0
	else:
		$alpha_tween.interpolate_property(self, "alpha", null, _new_alpha, fade_duration)
		$alpha_tween.start()



func _ready():
	MapManager.connect("map_changed", self, "_on_MapManager_map_changed")

func _process(delta):
	if Input.is_action_just_pressed("focus"):
		toggle_focus()
	
	for _key in object_alpha_pairs:
		Util.object_set_alpha(object_alpha_pairs[_key].object, object_alpha_pairs[_key].color_path, alpha)



func _on_MapManager_map_changed(map_name):
	clear_all()

func _on_FocusNode_tree_exiting(node):
	object_alpha_pairs.erase(node)
