extends Spatial

class_name CameraController

export var movementSpeed: float = 1.0

var controlZone = null
var controlCallbackName

func _ready():
	var _rect: Rect2
	
	_rect.position = Vector2.ZERO
	_rect.size = Vector2.ONE * 4.0
	
	set_control_mode(FollowPathType.RECT, _rect)

# warning-ignore:unused_argument
func _process(delta):
	translate(temp_movement() * movementSpeed * delta)
	
	call(controlCallbackName)

func temp_movement() -> Vector3:
	return Vector3(float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")), 0.0, float(Input.is_action_pressed("move_down")) - float(Input.is_action_pressed("move_up"))).normalized()

func set_control_mode(var mode: int, var controller) -> void:
	match mode:
		FollowPathType.PATH:
			controlCallbackName = "follow_path"
		FollowPathType.RECT:
			controlCallbackName = "follow_rect"
		FollowPathType.POINT:
			pass
	
	controlZone = controller

func follow_path() -> void:
	pass

func follow_rect() -> void:
	var _rect: Rect2 = controlZone
	
	translation.x = clamp(translation.x, -_rect.size.x, _rect.size.x)
	translation.z = clamp(translation.z, -_rect.size.y, _rect.size.y)

enum FollowPathType {
	PATH,
	RECT,
	POINT
}
