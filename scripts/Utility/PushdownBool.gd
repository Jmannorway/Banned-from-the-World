extends Reference

class_name PushdownBool

var stack : Dictionary

func weighted() -> bool:
	var _weighted = 0
	for i in stack:
		_weighted |= int(i)
	return bool(_weighted)

func push(node : Node, name := ""):
	if name.empty():
		name = node.name
	
	if stack.has(node.name):
		stack[name] = true
	
	Util.connect_safe(node, "tree_exited", self, "_on_pushed_node_tree_exited", [name])

func _on_pushed_node_tree_exited(binds : Array):
	if stack.has(binds[0]):
		stack[binds[0]] = false
