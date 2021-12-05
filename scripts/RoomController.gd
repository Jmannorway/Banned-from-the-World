tool
extends ImmediateGeometry

class_name Room3D

export (int, "Path", "Rect", "Point") var pathFollowType: int
export var offset: Vector2 setget set_room_rect_offset
export var size: Vector2 setget set_room_rect_size
export var rectHeight: float setget set_rect_height

func _ready():
	if !Engine.editor_hint:
		clear()

func set_room_rect_size(var newSize: Vector2) -> void:
	size = newSize
	draw_rect()

func set_room_rect_offset(var newOffset: Vector2) -> void:
	offset = newOffset
	draw_rect()

func set_rect_height(var height: float) -> void:
	rectHeight = height
	draw_rect()

func draw_rect() -> void:
	clear()
	
	if Engine.editor_hint:
		begin(Mesh.PRIMITIVE_TRIANGLES)
		
		if size.is_equal_approx(Vector2.ZERO):
			add_sphere(8, 8, 0.1)
		else:
			add_vertex(Vector3(size.x + offset.x, rectHeight, size.y + offset.y))
			add_vertex(Vector3(size.x + offset.x, rectHeight, -size.y + offset.y))
			add_vertex(Vector3(-size.x + offset.x, rectHeight, -size.y + offset.y))
			
			add_vertex(Vector3(-size.x + offset.x, rectHeight, -size.y + offset.y))
			add_vertex(Vector3(-size.x + offset.x, rectHeight, size.y + offset.y))
			add_vertex(Vector3(size.x + offset.x, rectHeight, size.y + offset.y))
		
		end()
