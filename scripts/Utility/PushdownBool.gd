extends Reference

class_name WeightedBool

var stack : Dictionary

func set_weight(name : String, val : bool):
	stack[name] = val

func is_weighted() -> bool:
	var _is := 0
	for key in stack:
		_is |= int(stack[key])
	return bool(_is)

func bind(name : String, node : Node):
	Util.connect_safe(node, "tree_exited", self, "_on_node_tree_exited", [name], CONNECT_ONESHOT)

func _on_node_tree_exited(binds : Array):
	set(binds[0], false)
