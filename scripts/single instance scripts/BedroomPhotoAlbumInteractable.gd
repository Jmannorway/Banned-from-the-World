extends Interactable

export var changeToScene: PackedScene
export var blankScene: PackedScene
var player : CharacterController3D = null
var _previous_rotation = -1

# warning-ignore:unused_argument
func _interact(var roomManager) -> void:
	if !activatePlayerAnimation.empty() and player != null:
		player.anim.travel(activatePlayerAnimation)
		player.set_frozen("book_animation", true)
		
		var _sceneTimer: SceneTreeTimer = get_tree().create_timer(player.animPlayer.get_animation(activatePlayerAnimation).length, false)
		_sceneTimer.connect("timeout", self, "change_on_anim_finished")
		
#		player.animPlayer.connect("animation_finished", self, "change_on_anim_finished")
		return
	
	change_on_anim_finished()

func change_on_anim_finished() -> void:
	Temp.goto_world(get_tree(), Game.WORLD.INNER)

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
