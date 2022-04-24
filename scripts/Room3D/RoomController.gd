tool
extends ImmediateGeometry

class_name Room3D

export var unlockStage: int = 0

export (int, "Rect", "Point") var pathFollowType: int setget set_follow_type
export var offset: Vector2 setget set_room_rect_offset
export var size: Vector2 setget set_room_rect_size
export var rectHeight: float setget set_rect_height

# the main gridmap always has to be a child of this script
onready var gridMap: GridMap = $room_grid

func _ready():
	if !Engine.editor_hint:
		$room_grid.visible = false
		clear()

func grab_transition_postion(var transitionName: String) -> Vector3:
	var _transitionChildren: Array = $room_events.get_children()
	
	for i in _transitionChildren.size():
		if _transitionChildren[i] is InteractableRoom and _transitionChildren[i].roomName == transitionName:
			return _transitionChildren[i].global_transform.origin
	
	return Vector3.ZERO

func activate(var status: bool) -> void:
	visible = status

func get_block(var position: Vector3) -> int:
	return gridMap.get_cell_item(int(position.x - round(translation.x)), int(position.y - round(translation.y)), int(position.z - round(translation.z)))

func is_block_solid(var position: Vector3) -> bool:
	return get_block(position) == 0

func set_follow_type(var value: int) -> void:
	pathFollowType = value
	draw_lineup()

func set_room_rect_size(var newSize: Vector2) -> void:
	size = newSize
	draw_lineup()

func set_room_rect_offset(var newOffset: Vector2) -> void:
	offset = newOffset
	draw_lineup()

func set_rect_height(var height: float) -> void:
	rectHeight = height
	draw_lineup()

func draw_lineup() -> void:
	clear()
	
	match pathFollowType:
		0:
			if is_zero_approx(size.x) or is_zero_approx(size.y):
				begin(Mesh.PRIMITIVE_LINES)
				
				add_vertex(Vector3(size.x + offset.x, rectHeight, size.y + offset.y))
				add_vertex(Vector3(-size.x + offset.x, rectHeight, -size.y + offset.y))
			else:
				begin(Mesh.PRIMITIVE_TRIANGLES)
				
				add_vertex(Vector3(size.x + offset.x, rectHeight, size.y + offset.y))
				add_vertex(Vector3(size.x + offset.x, rectHeight, -size.y + offset.y))
				add_vertex(Vector3(-size.x + offset.x, rectHeight, -size.y + offset.y))
				
				add_vertex(Vector3(-size.x + offset.x, rectHeight, -size.y + offset.y))
				add_vertex(Vector3(-size.x + offset.x, rectHeight, size.y + offset.y))
				add_vertex(Vector3(size.x + offset.x, rectHeight, size.y + offset.y))
		1:
			begin(Mesh.PRIMITIVE_LINES)
			
			add_vertex(Vector3(offset.x + 0.5, rectHeight, offset.y + 0.5))
			add_vertex(Vector3(offset.x - 0.5, rectHeight, offset.y - 0.5))
			
			add_vertex(Vector3(offset.x - 0.5, rectHeight, offset.y + 0.5))
			add_vertex(Vector3(offset.x + 0.5, rectHeight, offset.y - 0.5))
	
	end()
