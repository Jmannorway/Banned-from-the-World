tool
extends Interactable2D

export var size: Vector2 setget set_size
export var loopX: bool setget set_x_looping
export var loopY: bool setget set_y_looping
export var useRoomSize: bool setget set_use_room_size

signal on_mirror_teleport(direction)

func set_size(var value: Vector2) -> void:
	size = value
	
	value *= Game.SNAP
	
	if Engine.editor_hint:
		$above.position.y = -value.y
		$below.position.y = value.y
		
		$left.position.x = -value.x
		$right.position.x = value.x

func set_x_looping(var status: bool) -> void:
	loopX = status
	
	if Engine.editor_hint:
		$left.disabled = !loopX
		$right.disabled = !loopX
		
		$left.visible = loopX
		$right.visible = loopX

func set_y_looping(var status: bool) -> void:
	loopY = status
	
	if Engine.editor_hint:
		$above.disabled = !loopY
		$below.disabled = !loopY
		
		$above.visible = loopY
		$below.visible = loopY

func set_use_room_size(var status: bool) -> void:
	useRoomSize = status

func _ready():
	if Engine.editor_hint:
		return
	
	var _parent = get_parent()
	
	while !(_parent is RoomLoader2D) and _parent == get_tree():
		_parent = _parent.get_parent()
	
	if _parent is RoomLoader2D:
		size = _parent.size * 0.5 / float (Game.SNAP)
	
	$above.position.y = -size.y * Game.SNAP
	$below.position.y = size.y * Game.SNAP
	$left.position.x = -size.x * Game.SNAP
	$right.position.x = size.x * Game.SNAP
	
	$left.disabled = !loopX
	$right.disabled = !loopX
	$left.visible = loopX
	$right.visible = loopX
	
	$above.disabled = !loopY
	$below.disabled = !loopY
	$above.visible = loopY
	$below.visible = loopY

func step():
	pass

func interact():
	pass

func on_character_enter(var directionFrom: Vector2) -> void:
	var _teleportOffset: Vector2 = Vector2($right.position.x - $left.position.x, $below.position.y - $above.position.y)
	var _offset: Vector2 = directionFrom * Game.SNAP
	var _finalTeleportPosition: Vector2 = Vector2((directionFrom.x * _teleportOffset.x - _offset.x) * float(loopX), (directionFrom.y * _teleportOffset.y - _offset.y) * float(loopY))
	
	PlayerAccess.get_player_2d(get_tree()).move_position(-_finalTeleportPosition / float(Game.SNAP))
	Util.get_first_node_in_group(get_tree(), "camera").position -= _finalTeleportPosition
	
	emit_signal("on_mirror_teleport", directionFrom)

# warning-ignore:unused_argument
func on_character_exit(var directionTo: Vector2) -> void:
	pass
