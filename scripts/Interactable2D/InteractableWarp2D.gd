extends Interactable2D

export(String, FILE, "*.tscn") var map_path
export var player_start_index = 0
export var on_step := false
export(String) var player_animation = ""
var warping : bool = false

func warp():
	if warping:
		return
	
	warping = true
	var _player = PlayerAccess.get_player_2d(get_tree())
	_player.set_frozen("warp", true)
	
	var _camera = Util.get_first_node_in_group(get_tree(), "camera")
	_camera.target = null
	_camera.target_group = ""
	
	if !player_animation.empty():
		var _animation_player = _player.get_node("animations")
		_animation_player.play(player_animation)
		Util.connect_safe(_animation_player, "animation_finished", self, "_on_player_animation_finished")
	else:
		_warp()

func step():
	if on_step:
		warp()

func interact():
	if !on_step:
		warp()



func _on_player_animation_finished(anim_name : String):
	_warp()

func _warp():
	MapManager.transition_to_map_by_path(map_path, player_start_index)
