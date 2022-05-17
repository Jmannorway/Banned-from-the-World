tool
extends Node2D

export var offset: Vector2
export var clampArea: Vector2 = Vector2(100.0, 100.0) setget set_area
export var speed: Vector2 = Vector2.ONE
export var targetPath: NodePath

var isTracking: bool setget set_tracking
var target: Node2D

func set_area(var value: Vector2) -> void:
	clampArea = value
	
	if Engine.editor_hint:
#		update()
		pass

func set_tracking(var status: bool) -> void:
	isTracking = status
	
	set_process(isTracking)

func _ready():
	set_process(false)
	
	if Engine.editor_hint:
		return
	
	self.isTracking = true
	
	if targetPath.is_empty():
		target = Util.get_first_node_in_group(get_tree(), "camera")
	else:
		target = get_node(targetPath)

# warning-ignore:unused_argument
func _process(delta):
	# TODO: Temporary crash fix
	target = Util.get_first_node_in_group(get_tree(), "camera")
	
	if target:
		position = offset - Vector2(target.global_position.x * speed.x, target.global_position.y * speed.y)

func _draw():
	return
	
	var _rect: Rect2
	
	_rect.position = -clampArea * 0.5
	_rect.size = clampArea
	
	draw_rect(_rect, Color(0.4, 1.0, 0.0, 0.25))
