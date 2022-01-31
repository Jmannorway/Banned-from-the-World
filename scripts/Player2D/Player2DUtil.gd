class_name Player2DUtil

const PLAYER_2D_SCENE := preload("res://scenes/2d/character & player/player_2d.tscn")

static func instance_player_2d() -> Player2D:
	return PLAYER_2D_SCENE.instance() as Player2D

static func player_exists(tree : SceneTree) -> bool:
	var _players = tree.get_nodes_in_group("player")
	if _players.size() > 0:
		return true
	else:
		return false

static func get_player(tree : SceneTree) -> Player2D:
	return Util.get_first_node_in_group(tree, "player")
