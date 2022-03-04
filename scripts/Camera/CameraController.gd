extends Spatial

class_name CameraController

export var movementSpeed: float = 1.0

var isTransitioning: bool
var controlZone = null
var controlCallbackName: String
var toPoint: Vector3

var targetNode: Spatial = null

onready var tween: Tween = $tween_camera

func _ready():
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
			controlCallbackName = "follow_rect"
			controlZone = Rect2(controller.offset + Vector2(controller.translation.x, controller.translation.z), controller.size)
			toPoint = controller.grab_transition_postion(fromRoomName)
			
			var _rect: Rect2 = controlZone
			toPoint.x = clamp(toPoint.x, -_rect.size.x + _rect.position.x, _rect.size.x + _rect.position.x)
			toPoint.z = clamp(toPoint.z, -_rect.size.y + _rect.position.y, _rect.size.y + _rect.position.y)
		FollowPathType.POINT:
			controlCallbackName = "follow_point"
			toPoint = Vector3(controller.offset.x + controller.translation.x, 0.0, controller.offset.y + controller.translation.z)

func transition_to_room(var instant: bool = false) -> void:
	if instant:
		translation = toPoint
		return
	
	set_process(false)
	
# warning-ignore:return_value_discarded
	tween.remove_all()
# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "translation", null, toPoint, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
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

enum FollowPathType {
	RECT,
	POINT
}
