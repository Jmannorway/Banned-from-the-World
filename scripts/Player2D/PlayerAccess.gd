class_name PlayerAccess

# Adding player nodes to these groups is hard programatically because
# it is prone to creating cyclic dependency issues. Therefore I simply
# assume that the player nodes are added to these groups
# As long as the player nodes themself don't reference this script there
# should be no cyclic dependency issues. After all, the player shouldn't
# need to access itself.
const PLAYER_2D_SCENE := preload("res://scenes/2d/character & player/player_2d.tscn")
const PLAYER_3D_SCENE := preload("res://scenes/characters/max.tscn")
const PLAYER_2D_GROUP_NAME := "player_2d"
const PLAYER_3D_GROUP_NAME := "player_3d"

static func player_2d_exists(tree : SceneTree) -> bool:
	var _player = get_player_2d(tree)
	return _player != null

static func player_3d_exists(tree : SceneTree) -> bool:
	var _players = tree.get_nodes_in_group(PLAYER_3D_GROUP_NAME)
	return _players.size() > 0

static func get_player(tree : SceneTree):
	var _player_2d = get_player_2d(tree)
	return _player_2d if _player_2d else get_player_3d(tree)

static func get_player_2d(tree : SceneTree) -> Player2D:
	var _player = Util.get_first_node_in_group(tree, PLAYER_2D_GROUP_NAME)
	if _player && !Util.deep_is_queued_for_deletion(_player):
		return _player
	else:
		return null

static func get_player_3d(tree : SceneTree) -> CharacterController3D:
	var _player = Util.get_first_node_in_group(tree, PLAYER_3D_GROUP_NAME)
	if _player && !Util.deep_is_queued_for_deletion(_player):
		return _player
	else:
		return null

static func instance_player_2d() -> Player2D:
	return PLAYER_2D_SCENE.instance() as Player2D

static func instance_player_3d() -> CharacterController3D:
	return PLAYER_3D_SCENE.instance() as CharacterController3D

static func spawn_player_2d() -> Player2D:
	var _player = instance_player_2d()
	if MapManager.has_map():
		Util.reparent_to_deferred(_player, MapManager.current_map_instance)
	else:
		Util.reparent_to_deferred(_player, MapManager)
	return _player
