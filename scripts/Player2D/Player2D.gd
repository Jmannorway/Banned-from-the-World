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
export(Dictionary) var effects
var effect_index := 0
const EFFECT_ACTION_FUNC_PRESET = "action_"
static func create_effects_dictionary(default = null) -> Dictionary:
	var _eff := {}
	for n in EFFECT_NAMES:
		_eff[n] = default
	return _eff

var effect : String = EFFECT_NAMES[0] setget set_effect
func set_effect(val : String) -> void:
	if effect != val && effects.has(val):
		# Exit effect
		match effect:
			"skater":
				walk_speed = WALK_SPEED
				run_speed = RUN_SPEED
				set_move_speed(walk_speed)
			"dealer":
				MapManager.viewport_sprite.set_effect(0)
		
		effect = val
		
		# Enter effect
		match effect:
			"skater":
				walk_speed = RUN_SPEED * 2
				run_speed = RUN_SPEED * 2
				set_move_speed(walk_speed)
		
		sprite.frames = effects[effect].frames
		print("Player2D: ", effect)
	else:
		print("Player2D: Tried setting the same effect or invalid effect")

func _ready():
	# TODO: Connect to menu element that sets the effect
	Util.connect_safe(MapManager, "changing_map", self, "_on_MapManager_changing_map")
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")
	Util.connect_safe(Ui.get_menu(), "visibility_changed", self, "_on_menu_visibility_changed", [Ui.get_menu()])

func next_effect() -> void:
	var i : int = (effect_index + 1) % EFFECT._MAX
	while !Statistics.metadata.unlocked_effects[EFFECT_NAMES[i]]:
		print("Player2D: Skipped effect '", EFFECT_NAMES[i], "' because it was not unlocked")
		i = (i + 1) % EFFECT._MAX
	set_effect(EFFECT_NAMES[i])
	effect_index = i

func _process(_delta):
	if !frozen.is_weighted():
		if Input.is_action_just_pressed("ui_page_up"):
			next_effect()
		elif Input.is_action_just_pressed("ui_page_down"):
			effect_index = wrapi(effect_index - 1, 0, EFFECT_NAMES.size())
			set_effect(EFFECT_NAMES[effect_index])
		
		if Input.is_action_just_pressed("action"):
			call(EFFECT_ACTION_FUNC_PRESET + effect)
		
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

# ACTIONS
func action_normal() -> void:
	if move_speed == walk_speed:
		set_move_speed(run_speed)
	else:
		set_move_speed(walk_speed)

func action_dealer() -> void:
	MapManager.viewport_sprite.set_next_effect()

func action_skater() -> void:
	pass

func action_ballerina() -> void:
	pass

func action_katana() -> void:
	pass

# SIGNAL CALLBACKS
func _on_XToFocus_focus_changed(val):
	frozen.set_weight(XToFocus.name, val)

func _on_menu_visibility_changed(menu):
	frozen.set_weight(menu.name, menu.visible)

func _on_MapManager_changing_map():
	frozen.set_weight(MapManager.name, true)

# UTILITY
static func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

static func make_input_vector_4way(iv : Vector2) -> Vector2:
	return Vector2(
		iv.x,
		iv.y * (iv.x == 0) as int)
