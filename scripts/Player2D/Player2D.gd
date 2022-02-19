extends Character2D

class_name Player2D

var walk_speed := 2.0
var run_speed := 4.0
var frozen : bool

# Main functionality
func _ready():
	XToFocus.connect("focus_changed", self, "_on_XToFocus_focus_changed")

func _process(delta):
	if !frozen:
		if Input.is_action_pressed("run"):
			set_move_speed(run_speed)
		else:
			set_move_speed(walk_speed)
		
		var _movement_vector = make_input_vector_4way(get_input_vector())
		if !Util.compare_v2(_movement_vector, 0):
			queue_move(_movement_vector, 10)

func _post_process_move():
	if !is_moving() && !Util.compare_v2(facing, 0):
		character_sprite.set_sprite_direction(facing)
	
	if Input.is_action_just_pressed("interact") && !is_moving():
		$interactable_detector_2d.interact_with_facing(position, facing)

# Allows / prevents the player from reacting to inputs
func set_frozen(val : bool) -> void:
	frozen = val

func _on_XToFocus_focus_changed(val):
	set_frozen(val)

static func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

static func make_input_vector_4way(iv : Vector2) -> Vector2:
	return Vector2(
		iv.x,
		iv.y * (iv.x == 0) as int)
