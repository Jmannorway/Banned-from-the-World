extends Spatial

class_name RoomManager3D

var rooms: Dictionary

onready var mainCharacter: CharacterController3D = $max
onready var cameraController: CameraController = $main_camera

var controllingCamera: bool
var currentRoom
var currentRoomName: String

func _ready():
	get_rooms()
# warning-ignore:return_value_discarded
	prewarp_room(Statistics.metadata["room"], Statistics.metadata["position"])
	cameraController.set_follow_target(mainCharacter)
	
	mainCharacter.roomManager = self

func prewarp_room(var roomName: String, var position: Vector3) -> void:
# warning-ignore:return_value_discarded
	request_room_change(roomName, true)
	# set Max's position, through the position parameter
#	mainCharacter.teleport_to(position)
	
	check_for_room_availability()

func check_for_room_availability() -> void:
	for roomName in rooms:
		rooms[roomName].activate(Statistics.metadata["fog_stage"] >= rooms[roomName].unlockStage)

func request_room_change(var roomName: String, var instant: bool = false) -> Room3D:
	if !rooms.has(roomName):
		return null
	
	currentRoom = rooms[roomName]
	if controllingCamera:
		cameraController.set_control_mode(currentRoom.pathFollowType, currentRoomName, currentRoom)
		cameraController.transition_to_room(instant)
	currentRoomName = roomName
	
	return currentRoom

func get_rooms() -> void:
	var _roomNodes: Array = get_node("rooms").get_children()
	
	for i in _roomNodes.size():
		rooms[_roomNodes[i].name] = _roomNodes[i]

func _exit_tree():
	Statistics.metadata["room"] = currentRoomName
