extends GameViewportSprite

# TODO: Could be optimized to only change when player moves
var pass_player_position := false
var unprojected_position : Vector2

func _process(delta):
	if pass_player_position:
		match viewport.mode:
			viewport.MODE.TWO_DIMENSIONAL:
				var _player = PlayerAccess.get_player_2d(get_tree())
				material.set_shader_param("position", _player.position)
			viewport.MODE.THREE_DIMENSIONAL:
				var _player = PlayerAccess.get_player_3d(get_tree())
				var _camera = Util.get_first_node_in_group(get_tree(), "3d_camera")
				unprojected_position = _camera.camera.unproject_position(_player.translation)
				material.set_shader_param("position", unprojected_position)
