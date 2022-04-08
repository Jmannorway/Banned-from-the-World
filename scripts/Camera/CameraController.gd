extends Spatial

class_name CameraController

export var movementSpeed: float = 1.0
var trans = Tween.TRANS_SINE

var isTransitioning: bool
var transitionDuration: float = 4.0
var controlZone = null
var controlCallbackName: String
var toPoint: Vector3

var targetNode: Spatial = null

onready var tween: Tween = $tween_camera
onready var camera := $camera

func _ready():
	set_control_mode(FollowPathType.NOTHING, "", null)
# warning-ignore:return_value_discarded
	tween.connect("tween_all_completed", self, "on_transition_end")
	
	set_process(false)

# warning-ignore:unused_argument
func _process(delta):
	call(controlCallbackName)

func set_follow_target(var target: Spatial) -> void:
	targetNode = target

func set_control_mode(var mode: int, var fromRoomName: String, var controller) -> void:
	set_process(true)
	
	match mode:
		FollowPathType.RECT:
			camera.set_gameplay_position(transitionDuration)
			controlCallbackName = "follow_rect"
			controlZone = Rect2(controller.offset + Vector2(controller.translation.x, controller.translation.z), controller.size)
			toPoint = controller.grab_transition_postion(fromRoomName)
			
			var _rect: Rect2 = controlZone
			toPoint.x = clamp(toPoint.x, -_rect.size.x + _rect.position.x, _rect.size.x + _rect.position.x)
			toPoint.z = clamp(toPoint.z, -_rect.size.y + _rect.position.y, _rect.size.y + _rect.position.y)
		FollowPathType.POINT:
			camera.set_gameplay_position(transitionDuration)
			controlCallbackName = "follow_point"
			toPoint = Vector3(controller.offset.x + controller.translation.x, 0.0, controller.offset.y + controller.translation.z)
		_:
			camera.set_zero_position(transitionDuration)
			controlCallbackName = "follow_nothing"

func transition_to_node(var node: Spatial, var duration: float = -1.0):
	if duration == -1.0:
		duration = transitionDuration
	elif duration == 0.0:
		translation = node.translation
		rotation = node.rotation
		return
	
	tween.interpolate_property(self, "translation", null, node.translation, duration, trans)
	tween.interpolate_property(self, "rotation", null, node.rotation, duration, trans)
	tween.start()

func transition_to_room(var instant: bool = false) -> void:
	if instant:
		translation = toPoint
		return
	
	set_process(false)
	tween.interpolate_property(self, "translation", null, toPoint, 0.5, trans)
	tween.start()

func on_transition_end() -> void:
	set_process(true)

func follow_target() -> void:
	if targetNode == null:
		return
	
	translation = lerp(translation, targetNode.translation, 0.2)

# we don't have to do anything here, because the camera is going to be at a standstill here anyway
func follow_point() -> void:
	pass

func follow_rect() -> void:
	follow_target()
	
	var _rect: Rect2 = controlZone
	
	translation.x = clamp(translation.x, -_rect.size.x + _rect.position.x, _rect.size.x + _rect.position.x)
	translation.z = clamp(translation.z, -_rect.size.y + _rect.position.y, _rect.size.y + _rect.position.y)

func follow_nothing() -> void:
	pass

enum FollowPathType {
	NOTHING = -1
	RECT,
	POINT,
}
