extends KinematicBody

class_name CharacterController3D

export var movementSpeed: float = 4.0

var rotationDelta: float
var velocity: Vector3

onready var anim: AnimationNodeStateMachinePlayback = get_node("model/RootNode/AnimationTree").get("parameters/playback")

signal action_event(playerRef)

func _ready():
	$model/RootNode/AnimationTree.active = true

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("interact"):
		emit_signal("action_event", self)
		return
	
	if Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_left"):
		anim.travel("Walk")
	
	if !Input.is_action_pressed("move_down") and !Input.is_action_pressed("move_up") and !Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
		anim.travel("Idle")

func _physics_process(delta):
	velocity = movement() * movementSpeed * delta
	
	if !velocity.is_equal_approx(Vector3.ZERO):
		rotationDelta = Vector2(velocity.z, velocity.x).angle()
		$model.rotation.y = lerp_angle($model.rotation.y, rotationDelta, 0.2)
	
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func movement() -> Vector3:
	return Vector3(float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")), 0.0, float(Input.is_action_pressed("move_down")) - float(Input.is_action_pressed("move_up"))).normalized()
