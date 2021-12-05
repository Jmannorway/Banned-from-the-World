extends Spatial

class_name RoomManager3D

var rooms: Dictionary

onready var mainCharacter: CharacterController3D = get_node("max")
onready var mainCamera: CameraController = get_node("main_camera")

var currentRoom: Room3D

func _ready():
	get_rooms()
# warning-ignore:return_value_discarded
	request_room_change("bedroom")
	mainCamera.set_follow_target(mainCharacter)
	mainCamera.set_control_mode(currentRoom.pathFollowType, currentRoom)

func request_room_change(var roomName: String) -> Node:
	if !rooms.has(roomName):
		return null
	
	currentRoom = rooms[roomName]
	mainCamera.set_control_mode(currentRoom.pathFollowType, currentRoom)
	mainCamera.transition_to_room()
	
	return currentRoom

func get_rooms() -> void:
	var _roomNodes: Array = get_node("rooms").get_children()
	
	for i in _roomNodes.size():
		rooms[_roomNodes[i].name] = _roomNodes[i]
