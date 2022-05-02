extends Interactable

export var changeToScene: PackedScene
export var blankScene: PackedScene
var player : CharacterController3D = null
var _previous_rotation = -1

# warning-ignore:unused_argument
func _interact(var roomManager) -> void:
	Util.goto_world(get_tree(), Game.WORLD.INNER)
#	get_tree().change_scene_to(blankScene)
#	MapManager.warp_to_map(changeToScene, 0)
#	Game.set_world(Game.WORLD.INNER)

func _process(delta: float) -> void:
	if is_instance_valid(player):
		if player.rotation_degrees.y != _previous_rotation:
			if player.rotation_degrees.y == 180.0:
				Ui.get_action_hint().show_action_hint(Ui.get_action_hint().HINT.Z)
			else:
				Ui.get_action_hint().hide_action_hint()
		_previous_rotation = player.rotation_degrees.y

func _on_photo_album_area_entered(area):
	player = PlayerAccess.get_player_3d(get_tree())
