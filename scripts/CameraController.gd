extends Spatial

class_name CameraController

export var movementSpeed: float = 1.0

var controlZone = null
var controlCallbackName

var targetNode: Spatial = null

onready var tween: Tween = get_node("Tween")

# warning-ignore:unused_argument
func _process(delta):
	follow_target()
	
	call(controlCallbackName)

func set_follow_target(var target: Spatial) -> void:
	targetNode = target

func set_control_mode(var mode: int, var controller: Room3D) -> void:
	match mode:
		FollowPathType.PATH:
			controlCallbackName = "follow_path"
		FollowPathType.RECT:
			controlCallbackName = "follow_rect"
			controlZone = Rect2(controller.offset + Vector2(controller.translation.x, controller.translation.z), controller.size)
			print()
		FollowPathType.POINT:
			pass

func transition_to_room() -> void:
	pass

func follow_target() -> void:
	if targetNode == null:
		return
	
	translation = targetNode.translation

func follow_path() -> void:
	pass

func follow_rect() -> void:
	var _rect: Rect2 = controlZone
	
	translation.x = clamp(translation.x, -_rect.size.x + _rect.position.x, _rect.size.x+ _rect.position.x)
	translation.z = clamp(translation.z, -_rect.size.y + _rect.position.y, _rect.size.y + _rect.position.y)

enum FollowPathType {
	PATH,
	RECT,
	POINT
}
