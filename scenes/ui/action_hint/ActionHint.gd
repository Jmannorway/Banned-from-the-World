extends AnimatedSprite

class_name ActionHint

enum HINT{SHIFT, Z, X, C}
enum STATE {INVISIBLE, FADE_IN, VISIBLE, FADE_OUT, _MAX}

const BUTTON = ["run", "interact", "focus", "menu"]

export(float) var fade_duration = 1.0
var state : int = STATE.INVISIBLE setget set_state
var hint : int = HINT.SHIFT setget set_hint
var check_held := false
var timed := false

onready var alpha_tween = $action_hint_visibility_tween
onready var visibility_timer = $action_hint_visibility_timer

# The usable functions
func show_action_hint(action : int, duration := 0.0, held := false):
	if duration != 0.0:
		visibility_timer.wait_time = duration
		timed = true
	else:
		timed = false
	
	check_held = held
	
	if !hint_button_pressed():
		set_hint(action)
		set_state(STATE.FADE_IN)

func hide_action_hint():
	if state == STATE.FADE_IN || state == STATE.VISIBLE:
		set_state(STATE.FADE_OUT)

# How it works
func _ready():
	set_state(state)

func _process(delta):
	$border.modulate.a = modulate.a
	if hint_button_pressed() && state != STATE.INVISIBLE:
		set_state(STATE.FADE_OUT)

# Internal utility
func hint_button_pressed() -> bool:
	if check_held:
		return Input.is_action_pressed(BUTTON[hint])
	else:
		return Input.is_action_just_pressed(BUTTON[hint])

func set_hint(new_hint : int):
	match new_hint:
		HINT.SHIFT:
			animation = "shift"
		HINT.Z:
			animation = "z"
		HINT.X:
			animation = "x"
		HINT.C:
			animation = "c"
	
	if new_hint == HINT.SHIFT:
		$border.animation = "long"
	else:
		$border.animation = "normal"
	
	hint = new_hint

func fade(fade_in : bool, tween_progress := 1.0) -> void:
	var _fade_duration = fade_duration
	if (state == STATE.FADE_IN && !fade_in) || (state == STATE.FADE_OUT && fade_in):
		_fade_duration *= tween_progress
	
	alpha_tween.interpolate_property(self, "modulate:a", null, int(fade_in), _fade_duration)
	alpha_tween.start()

func next_state() -> void:
	set_state((state + 1) % STATE._MAX)

func set_state(new_state : int) -> void:
	var _tween_progress := 0.0
	
	# Stop any running tweening and calculate the amount of time left
	if alpha_tween.is_active():
		_tween_progress = alpha_tween.tell() / alpha_tween.get_runtime()
		alpha_tween.stop_all()
	
	if !visibility_timer.is_stopped():
		visibility_timer.stop()
	
	match new_state:
		STATE.INVISIBLE:
			modulate.a = 0.0
		STATE.FADE_IN:
			if modulate.a == 1.0:
				state = new_state
				next_state()
				return
			else:
				fade(true, _tween_progress)
		STATE.VISIBLE:
			modulate.a = 1.0
			if timed:
				visibility_timer.start()
		STATE.FADE_OUT:
			if modulate.a == 0.0:
				state = new_state
				next_state()
				return
			else:
				fade(false, _tween_progress)
	
	state = new_state

func is_timer_set() -> bool:
	return visibility_timer.wait_time != 0.0

# Callbacks
func _on_action_hint_visibility_tween_tween_all_completed():
	if state == STATE.FADE_IN || state == STATE.FADE_OUT:
		next_state()

func _on_action_hint_visibility_timer_timeout():
	if state == STATE.VISIBLE:
		next_state()
