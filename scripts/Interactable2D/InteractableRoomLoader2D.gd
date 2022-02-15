extends Interactable2D

export(String) var room_name
export(bool) var on_step = true
export(bool) var teleport
export(bool) var teleport_relative
export(Vector2) var teleport_coords

onready var group_name : String = get_groups()[0]
var previous_room_name : String
const TRANSITION_LENGTH_MAX := 2.0

func goto():
	MapManager.get_room_manager().smooth_transition_to_room(room_name)
	var _player = PlayerAccess.get_player_2d(get_tree())
	if teleport && _player:
		if teleport_relative:
			_player.position += teleport_coords
		else:
			_player.position = teleport_coords

func step():
	if on_step && !MapManager.get_room_manager().room_is_current(room_name):
		goto()

func interact():
	if !on_step && !MapManager.get_room_manager().room_is_current(room_name):
		goto()
