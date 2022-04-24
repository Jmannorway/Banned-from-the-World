extends Interactable2D

export(String) var room_name
export(int) var room_layer = -1
enum ActivationEvent{STEP, INTERACT, PEER}
export(ActivationEvent) var activation_event = ActivationEvent.PEER;
export(bool) var teleport
export(bool) var teleport_relative
export(Vector2) var teleport_coords

onready var group_name : String = get_groups()[0]
var previous_room_name : String
const TRANSITION_LENGTH_MAX := 2.0

func goto():
	var _player = PlayerAccess.get_player_2d(get_tree())
	MapManager.get_room_manager().smooth_transition_to_room(room_name, room_layer)
	if teleport && _player:
		if teleport_relative:
			_player.position += teleport_coords
		else:
			_player.position = teleport_coords

func step():
	if activation_event == ActivationEvent.STEP && !MapManager.get_room_manager().room_is_current(room_name):
		goto()

func interact():
	if activation_event == ActivationEvent.INTERACT && !MapManager.get_room_manager().room_is_current(room_name):
		goto()

func peer():
	if activation_event == ActivationEvent.PEER && !MapManager.get_room_manager().room_is_current(room_name):
		goto()
