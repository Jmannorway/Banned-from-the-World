extends Area

class_name CharacterController3D

export var movementSpeed: float = 4.0
export var moveOffset: float = 1.0
export var moveTime: float = 0.4

var interactiveReference: Interactable = null
var canMove: bool = true
var rotationDelta: float
var velocity: Vector3
var position: Vector2

var roomManager = null

const gridOffset: Vector3 = Vector3(0.5, 0.0, -0.5)

onready var tweenMovement: Tween = $tween_movement
onready var anim: AnimationNodeStateMachinePlayback = get_node("model/RootNode/AnimationTree").get("parameters/playback")

# warning-ignore:unused_signal
signal action_event(playerRef)

func _ready():
	$model/RootNode/AnimationTree.active = true
	Util.connect_safe(XToFocus, "focus_changed", self, "on_focus_changed")
	# warning-ignore:return_value_discarded
	connect("area_entered", self, "on_enter_area")
# warning-ignore:return_value_discarded
	connect("area_exited", self, "on_exit_area")
	
# warning-ignore:return_value_discarded
	tweenMovement.connect("tween_all_completed", self, "tween_position_completed")
# warning-ignore:return_value_discarded
	tweenMovement.connect("tween_step", self, "tween_position_steps")
	
	position.x = translation.x
	position.y = translation.z

func on_enter_area(var otherArea: Area) -> void:
	interactiveReference = otherArea

# warning-ignore:unused_argument
func on_exit_area(var otherArea: Area) -> void:
	interactiveReference = null

func on_focus_changed(var focus: bool) -> void:
	canMove = !focus

func teleport_to(var newPosition: Vector3) -> void:
	translation = newPosition + gridOffset
	position.x = translation.x
	position.y = translation.z

func get_integer_position():
	return Vector3(floor(translation.x), floor(translation.y), floor(translation.z))

func move(var direction: int) -> void:
	var _currentPosition: Vector2 = position
	var _currentRotation: float = rotation.y
	
	match direction:
		MoveDirection.RIGHT:
			position.x += moveOffset
			rotation.y = PI * 0.5
		MoveDirection.LEFT:
			position.x -= moveOffset
			rotation.y = -PI * 0.5
		MoveDirection.DOWN:
			position.y += moveOffset
			rotation.y = 0.0
		MoveDirection.UP:
			position.y -= moveOffset
			rotation.y = PI
	
	if roomManager.currentRoom.is_block_solid(Vector3(position.x - 0.5, translation.y, position.y - 0.5)): # check gridmap for occupied spaces
		position = _currentPosition
		
		anim.travel("idle")
		return
	
# warning-ignore:return_value_discarded
	tweenMovement.interpolate_property(self, "position", _currentPosition, position, moveTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
	tweenMovement.start()
	
	anim.travel("walk")
	
	canMove = false

func check_minigame_event() -> bool:
	return roomManager.currentRoom.get_block(Vector3(position.x - 0.5, translation.y, position.y - 0.5)) == 1

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("interact") and interactiveReference != null:
		interactiveReference._interact(roomManager)
		return
	
	if canMove:
		if Input.is_action_pressed("move_up"):
			move(MoveDirection.UP)
		elif Input.is_action_pressed("move_down"):
			move(MoveDirection.DOWN)
		elif Input.is_action_pressed("move_left"):
			move(MoveDirection.LEFT)
		elif Input.is_action_pressed("move_right"):
			move(MoveDirection.RIGHT)
	
#	if Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_left"):
#		anim.travel("Walk")
#
#	if !Input.is_action_pressed("move_down") and !Input.is_action_pressed("move_up") and !Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
#		anim.travel("Idle")

#func _physics_process(delta):
#	velocity = movement() * movementSpeed * delta
#
#	if !velocity.is_equal_approx(Vector3.ZERO):
#		rotationDelta = Vector2(velocity.z, velocity.x).angle()
#		$model.rotation.y = lerp_angle($model.rotation.y, rotationDelta, 0.2)
#
## warning-ignore:return_value_discarded
#	move_and_slide(velocity)

#func movement() -> Vector3:
#	return Vector3(float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")), 0.0, float(Input.is_action_pressed("move_down")) - float(Input.is_action_pressed("move_up"))).normalized()

func tween_position_steps(var _object: Object, var _key: NodePath, var _elapsed: float, var value: Vector2) -> void:
	translation.x = value.x
	translation.z = value.y

func tween_position_completed() -> void:
	canMove = true
	
	if Input.is_action_pressed("move_up"):
		move(MoveDirection.UP)
	elif Input.is_action_pressed("move_down"):
		move(MoveDirection.DOWN)
	elif Input.is_action_pressed("move_left"):
		move(MoveDirection.LEFT)
	elif Input.is_action_pressed("move_right"):
		move(MoveDirection.RIGHT)
	else:
		anim.travel("idle")

func _exit_tree():
	Statistics.metadata["position"] = translation - gridOffset

enum MoveDirection{
	UP,
	LEFT,
	DOWN,
	RIGHT
}
