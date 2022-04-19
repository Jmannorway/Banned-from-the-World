extends Spatial

class_name CameraController

export var movementSpeed: float = 1.0
var tweenTrans = Tween.TRANS_SINE

var isTransitioning: bool
var transitionDuration: float = 4.0
var controlZone = null
var controlCallbackName: String = FollowPathCallbackNames[FollowPathType.NOTHING]
var toPoint: Vector3

var targetNode: Spatial = null

onready var tween: Tween = $tween_camera
onready var camera := $target_offset/camera

func _ready():
# warning-ignore:return_value_discarded
	tween.connect("tween_all_completed", self, "on_transition_end")

	set_process(false)

# warning-ignore:unused_argument
func _process(delta):
	call(controlCallbackName)

func set_follow_target(var target: Spatial) -> void:
	targetNode = target

func set_control_mode(var mode: int, var fromRoomName: String, var controller, var instant := false) -> void:
	set_process(true)

	

	controlCallbackName = FollowPathCallbackNames[mode]
	var _transDur = transitionDuration * int(!instant)

	match mode:
		FollowPathType.RECT:
			camera.tween_to_gameplay_position(_transDur)
			controlZone = Rect2(controller.offset + Vector2(controller.translation.x, controller.translation.z), controller.size)
			toPoint = controller.grab_transition_postion(fromRoomName)

			var _rect: Rect2 = controlZone
			toPoint.x = clamp(toPoint.x, -_rect.size.x + _rect.position.x, _rect.size.x + _rect.position.x)
			toPoint.z = clamp(toPoint.z, -_rect.size.y + _rect.position.y, _rect.size.y + _rect.position.y)
		FollowPathType.POINT:
			camera.tween_to_gameplay_position(_transDur)
			toPoint = Vector3(controller.offset.x + controller.translation.x, 0.0, controller.offset.y + controller.translation.z)
		_:
			camera.tween_to_position(Vector3.ZERO, Vector3.ZERO)

func transition_to_room(var instant: bool = false) -> void:
	if instant:
		translation = toPoint
		return

	set_process(false)
	tween.interpolate_property(self, "translation", null, toPoint, 0.5, tweenTrans)
	tween.start()

# Animation shorthand functions
func tween_to_first_node_in_group(var group_name: String, var transition_type : int = -1, var duration: float = -1.0):
	camera.tween_to_node(Util.get_first_node_in_group(get_tree(), group_name), transition_type, duration)

func set_lookat_target_first_node_in_group(group_name : String):
	camera.set_lookat_target(Util.get_first_node_in_group(get_tree(), group_name))

func unset_lookat_target():
	camera.set_lookat_target(null)

func tween_to_gameplay_position(duration : float = -1.0):
	camera.tween_to_gameplay_position(duration)

func apply_offsets():
	$target_offset.apply_offsets()

func add_offset_target_first_node_in_group(group_name : String, _offset_translation : bool, _offset_rotation : bool) -> void:
	$target_offset.add_offset_target(
		Util.get_first_node_in_group(get_tree(), group_name),
		_offset_translation,
		_offset_rotation)

# Callbacks
func on_transition_end() -> void:
	set_process(true)

func _follow_target() -> void:
	translation = lerp(translation, targetNode.translation, 0.2)

# we don't have to do anything here, because the camera is going to be at a standstill here anyway
func _follow_point() -> void:
	pass

func _follow_rect() -> void:
	_follow_target()
	var _rect: Rect2 = controlZone
	translation.x = clamp(translation.x, -_rect.size.x + _rect.position.x, _rect.size.x + _rect.position.x)
	translation.z = clamp(translation.z, -_rect.size.y + _rect.position.y, _rect.size.y + _rect.position.y)

func _follow_nothing() -> void:
	pass

enum FollowPathType {
	NOTHING = -1
	RECT,
	POINT
}

const FollowPathCallbackNames = [
	"_follow_rect",
	"_follow_point",
	"_follow_nothing"
]

