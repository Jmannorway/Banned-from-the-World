extends Character2D

class_name Player2D

var walk_speed := 2.0
var run_speed := 4.0

func _ready():
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")
	Util.connect_safe(Ui.get_menu(), "visibility_changed", self, "_on_menu_visibility_changed", [Ui.get_menu()])

func _process(_delta):
	if !frozen.is_weighted():
		if Input.is_action_pressed("run"):
			set_move_speed(run_speed)
		else:
			set_move_speed(walk_speed)
		
		var _input_vector = make_input_vector_4way(get_input_vector())
		if !Util.compare_v2(_input_vector, 0) && !is_moving():
			if check_solid_relative(_input_vector):
				set_facing(_input_vector)
			else:
				queue_move(_input_vector)

func _post_process_move():
	._post_process_move()
	
	if !frozen.is_weighted() && Input.is_action_just_pressed("interact") && !is_moving():
		$interactable_detector_2d.interact_with_facing(self, calculate_move_offset(facing))

# SIGNAL CALLBACKS
func _on_XToFocus_focus_changed(val):
	frozen.set_weight(XToFocus.name, val)

func _on_menu_visibility_changed(menu):
	frozen.set_weight(menu.name, menu.visible)

# UTILITY
static func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

static func make_input_vector_4way(iv : Vector2) -> Vector2:
	return Vector2(
		iv.x,
		iv.y * (iv.x == 0) as int)
