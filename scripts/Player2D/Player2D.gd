extends Character2D

class_name Player2D

const WALK_SPEED := 2.0
const RUN_SPEED := 4.0
var walk_speed := 2.0
var run_speed := 4.0

enum EFFECT {NORMAL, KATANA, DEALER, BALLERINA, SKATER, GHOST, _MAX}
const EFFECT_NAMES := [
	"normal",
	"katana",
	"dealer",
	"ballerina",
	"skater",
	"ghost"]
onready var effect_state := $effect_state
onready var interactable_detector := $interactable_detector_2d

func _ready():
	# TODO: Connect to menu element that sets the effect
	Util.connect_safe(MapManager, "changing_map", self, "_on_MapManager_changing_map")
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")
	Util.connect_safe(Ui.get_menu(), "visibility_changed", self, "_on_menu_visibility_changed", [Ui.get_menu()])
	effect_state.init([self])

func set_effect(val : String):
	$animations.play("transition_animation (copy)")
	wait($animations.get_animation("transition_animation (copy)").length)
	effect_state.swap_next()
	return
	if effect_state.get_current_state().name == val:
		effect_state.pop()
	else:
		if effect_state.get_stack_size() == 1:
			effect_state.push_by_name(val)
		else:
			effect_state.swap_by_name(val)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		effect_state.get_current_state().action()

# SIGNAL CALLBACKS
func _on_XToFocus_focus_changed(val):
	set_frozen(XToFocus.name, val)

func _on_menu_visibility_changed(menu):
	set_frozen(menu.name, menu.visible)

func _on_MapManager_changing_map():
	set_frozen(MapManager.name, true)

# UTILITY
static func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

static func get_input_index() -> int:
	return (Input.get_action_strength("move_up") +
		Input.get_action_strength("move_right") * 2 +
		Input.get_action_strength("move_down") * 4 +
		Input.get_action_strength("move_left") * 8) as int

static func make_input_vector_4way(iv : Vector2) -> Vector2:
	return Vector2(
		iv.x,
		iv.y * (iv.x == 0) as int)
