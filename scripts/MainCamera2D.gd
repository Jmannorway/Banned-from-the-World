extends Camera2D

export var target_group : String
var target : Node2D

func _ready() -> void:
	pass

func _process(delta):
	if target:
		offset = target.position
	else:
		var _group = get_tree().get_nodes_in_group(target_group)
		if _group.size() > 0:
			target = _group[0]
