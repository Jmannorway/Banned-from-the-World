extends Camera2D

export var target_group := Player2DUtil.PLAYER_GROUP_NAME
var target : Node2D
var target_is_character := true

func _process(delta):
	if is_instance_valid(target):
		if target_is_character:
			offset = target.get_animated_position()
		else:
			offset = target.position
	else:
		target = Util.get_first_node_in_group(get_tree(), target_group)
