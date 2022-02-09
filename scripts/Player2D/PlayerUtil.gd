class_name PlayerUtil

const PLAYER_2D_SCENE := preload("res://scenes/2d/character & player/player_2d.tscn")
const PLAYER_2D_GROUP_NAME := "player_2d"
const PLAYER_3D_SCENE := preload("res://scenes/characters/max.tscn")
const PLAYER_3D_GROUP_NAME := "player_3d"

static func instance_player_2d() -> Player2D:
	return PLAYER_2D_SCENE.instance() as Player2D

static func instance_player_3d():
	return PLAYER_3D_SCENE.instance()

static func player_2d_exists(tree : SceneTree) -> bool:
	var _players = tree.get_nodes_in_group(PLAYER_2D_GROUP_NAME)
	return _players.size() > 0

static func player_3d_exists(tree : SceneTree) -> bool:
	var _players = tree.get_nodes_in_group(PLAYER_3D_GROUP_NAME)
	return _players.size() > 0

static func get_player(tree : SceneTree):
	var _player_2d = get_player_2d(tree)
	return _player_2d if _player_2d else get_player_3d(tree)

static func get_player_2d(tree : SceneTree) -> Player2D:
	return Util.get_first_node_in_group(tree, PLAYER_2D_GROUP_NAME)

static func get_player_3d(tree : SceneTree):
	return Util.get_first_node_in_group(tree, PLAYER_3D_GROUP_NAME)
