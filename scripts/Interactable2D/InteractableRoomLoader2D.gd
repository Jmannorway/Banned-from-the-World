extends Interactable2D

export(String) var room_name
export(bool) var on_step = true
export(bool) var teleport
export(bool) var teleport_relative
export(Vector2) var teleport_coords
var active := false

onready var group_name : String = get_groups()[0]
var previous_room_name : String
const TRANSITION_LENGTH_MAX := 2.0

func _ready():
	Util.connect_safe(MapManager.get_room_manager(), "room_focused", self, "_on_RoomManager_room_focused")

func _on_RoomManager_room_focused(room_name, room_loader_node):
	active = false
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	active = true

func goto():
	MapManager.get_room_manager().change_room(room_name)
	var _player = PlayerAccess.get_player_2d(get_tree())
	if teleport && _player:
		if teleport_relative:
			_player.position += teleport_coords
		else:
			_player.position = teleport_coords

func can_warp() -> bool:
	return !MapManager.get_room_manager().room_is_current(room_name) && active

func step():
	if on_step && can_warp():
		goto()

func interact():
	if !on_step && can_warp():
		goto()
