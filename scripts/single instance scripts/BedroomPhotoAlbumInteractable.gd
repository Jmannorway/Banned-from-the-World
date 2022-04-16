extends Interactable

export var changeToScene: PackedScene
export var blankScene: PackedScene

# warning-ignore:unused_argument
func _interact(var roomManager) -> void:
	Util.goto_world(get_tree(), Game.WORLD.INNER)
#	get_tree().change_scene_to(blankScene)
#	MapManager.warp_to_map(changeToScene, 0)
#	Game.set_world(Game.WORLD.INNER)

func _on_photo_album_area_entered(area):
	print("entered")
	var _player = PlayerAccess.get_player_3d(get_tree())
	if _player && _player.rotation_degrees.y == 180:
		Ui.get_action_hint().show_action_hint(Ui.get_action_hint().HINT.Z)

func _on_photo_album_area_exited(area):
	Ui.get_action_hint().hide_action_hint()
