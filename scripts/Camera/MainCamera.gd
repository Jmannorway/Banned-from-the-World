tool

extends Camera

enum TRANSITION_TYPE {NONE = -1, MOVE, FADE}

var fade_duration : float = 2.0
var lookat_target : Spatial setget set_lookat_target
func set_lookat_target(target : Spatial):
	lookat_target = target

onready var blocking_material = $blocking_mesh.get_surface_material(0)

export(int) var tween_move_transition := Tween.TRANS_SINE
export(bool) var fade_out_on_ready = true
export(float) var dim_alpha = 1.0
export(float) var default_transition_duration = 4.0

export(Vector3) var gameplay_translation setget set_gameplay_translation
func set_gameplay_translation(val):
	gameplay_translation = val
	if Engine.editor_hint:
		translation = val

export(Vector3) var gameplay_rotation_degrees setget set_gameplay_rotation_degrees
func set_gameplay_rotation_degrees(val):
	gameplay_rotation_degrees = val
	if Engine.editor_hint:
		rotation_degrees = val

func _ready():
	if !Engine.editor_hint:
		tween_to_position(Vector3.ZERO, Vector3.ZERO, TRANSITION_TYPE.NONE, 0.0)
	if fade_out_on_ready:
		dim_alpha = 1.0
		fade(true)
	
func _process(delta):
	if !Engine.editor_hint:
		blocking_material.albedo_color.a = dim_alpha
		if is_instance_valid(lookat_target):
			look_at(lookat_target.translation, Vector3.UP)

func is_transitioning() -> bool:
	return $position_tween.is_active()

##
## Tweens the camera's current position and rotation to a node
##
## @desc:
##	Sets the camera's positions and rotation to another node's position and rotation
##	over a period of time. You can select to have it fade in&out or move between the two
##	positions over a set duration. 
##	1) Remember that the camera might be offset with the camera controller's translation and rotation
##	2) This ignores the camera controller's translation and rotation offset by using the camera's
##		global rotation and translation
##
func tween_to_node(node : Spatial, transition_type : int = TRANSITION_TYPE.MOVE, duration : float = -1.0):
	tween_to_position(node.translation, node.rotation, transition_type, duration)

func tween_to_gameplay_position(duration : float = -1.0):
	tween_to_position(
		gameplay_translation,
		Vector3(deg2rad(gameplay_rotation_degrees.x), deg2rad(gameplay_rotation_degrees.y), deg2rad(gameplay_rotation_degrees.z)),
		TRANSITION_TYPE.MOVE,
		duration)

func tween_to_position(trans : Vector3, rot : Vector3, transition_type : int = TRANSITION_TYPE.MOVE, duration : float = -1.0):
	duration = default_transition_duration if duration == -1.0 else duration
	match transition_type:
		TRANSITION_TYPE.MOVE:
			$transition_tween.interpolate_property(self, "translation", null, trans, duration, tween_move_transition)
			$transition_tween.interpolate_property(self, "rotation", null, rot, duration, tween_move_transition)
			$transition_tween.start()
		TRANSITION_TYPE.FADE:
			$transition_tween.interpolate_property(self, "dim_alpha", null, 1, duration / 2.0)
			$transition_tween.interpolate_callback($transition_tween, duration / 2.0, "interpolate_property", self, "dim_alpha", null, 0, duration / 2.0)
			$transition_tween.interpolate_callback(self, duration / 2.0, "set", "translation", trans)
			$transition_tween.interpolate_callback(self, duration / 2.0, "set", "rotation", rot)
			$transition_tween.start()
		_:
			translation = trans
			rotation = rot
			pass

func fade(out : bool, duration : float = -1.0) -> void:
	fade_duration = fade_duration if duration == -1.0 else duration
	$alpha_tween.interpolate_property(self, "dim_alpha", null, 0 if out else 1, fade_duration)
	$alpha_tween.start()
