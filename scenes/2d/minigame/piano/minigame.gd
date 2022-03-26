extends Node2D

# This class has two tasks
# 1) keeping track of the state of the minigame
# 2) making sure the minigame runs with correct timing
export(float) var arrow_visibility_window = 2.5
export(float) var offset = 0.0
export(int, 1, 16) var denominator = 4
export(Array, AudioStream) var key_sounds

export(float) var bpm = 120.0 setget set_bpm
func set_bpm(new_bpm):
	bpm = new_bpm
	bps = bpm / 60.0

var bps := 2.0 setget set_bps
func set_bps(new_bps):
	bps = new_bps
	bpm = bps * 60.0

onready var detection = $detection
var started : bool
var change_arrow : bool
var song_position : float
var state
var move_direction : int
var force_x : bool = true
var input_sequence : Array

func _ready():
	$timing.initialize(bpm, denominator, arrow_visibility_window)
	Util.connect_safe(XToFocus, "focus_changed", self, "_on_XToFocus_focus_changed")

func set_state(state_name : String):
	if state:
		state.removed()
	state = get_node("states/" + state_name)
	state.initialize(self, $spawner, $movement_direction)
	state.added()

func press(dir : int):
	if !started:
		for i in Game.DIR4.MAX:
			if detection.is_overlapping(i):
				detection.remove_first(i)
		detection.arrow_feedback(dir)
		input_sequence.push_back(dir)
		MusicManager.play_sound(key_sounds[dir])
	else:
		print("PianoMinigame: Minigame is not started, not accepting inputs")

func start() -> bool:
	if started:
		print("PianoMinigame: Minigame is already started")
		return false
	
	if XToFocus.focus:
		print("PianoMinigame: Currently focused can't start")
		return false
	
	if !state:
		print("PianoMinigame: No state was set. Defaulting to tutorial")
		set_state("tutorial")
	
	_start()
	return true

func _start():
	started = true
	$timing.start(offset)
	get_tree().create_timer($timing.get_bar_rate()).connect("timeout", $music, "play")
	$spawner.speed = get_spawner_detector_distance() / arrow_visibility_window
	$spawner.queue_state($spawner.STATE.SPAWNING)

func get_spawner_detector_distance() -> float:
	return $spawner.spawn_distance - $detection.key_distance

func evaluate_sequence(_input_sequence, _spawner_sequence) -> int:
	var _sequence = _spawner_sequence.duplicate()
	if _input_sequence.size() != _spawner_sequence.size():
		print("Minigame: Sequence lengths are not the same (", _input_sequence.size(), ", ", _spawner_sequence.size(), ")")
		return -1
	elif _input_sequence.size() >= Game.DIR4.MAX && _spawner_sequence.size() >= Game.DIR4.MAX:
		var _correct_inputs = 0
		for i in Game.DIR4.MAX:
			for j in Game.DIR4.MAX:
				if _input_sequence[j] == _sequence[j]:
					_correct_inputs += 1
				_sequence[j] = (_sequence[j] + 1) % Game.DIR4.MAX
			if _correct_inputs == _spawner_sequence.size():
				print($movement_direction.previous_direction)
				return (i + $movement_direction.previous_direction) % Game.DIR4.MAX
			_correct_inputs = 0
	
	print("Minigame: Couldn't find a valid sequence")
	return -1

func _on_timing_bar(bar):
	state.bar()

func _on_timing_rhythm(beat, bar):
	for i in get_tree().get_nodes_in_group("note_glow_animation_players"):
		i.play("glow")
	state.rhythm()

func _on_timing_spawn_bar(bar):
	state.spawn_bar()

func _on_timing_spawn_rhythm(beat, bar):
	state.spawn_rhythm()

func _on_spawner_changed_state(state):
	match state:
		PianoMinigameSpawner.STATE.SPAWNING:
			input_sequence.clear()
			XToFocus.set_process_input(false)
			Ui.action_hint.hide_action_hint()
		PianoMinigameSpawner.STATE.PAUSED:
			# Waiting for the current bar to finish ensures that all rhythm
			# game hit objects have been either pressed or missed
			yield($timing, "bar")
			XToFocus.set_process_input(true)
			Ui.action_hint.show_action_hint(Ui.action_hint.HINT.X)
			get_tree().create_timer($timing.get_rhythm_rate()).connect("timeout", self, "_on_sequence_finish")

func _on_sequence_finish():
	print(input_sequence, $spawner.sequence)
	var dir = evaluate_sequence(input_sequence, $spawner.sequence)
	var _player = PlayerAccess.get_player_3d(get_tree())
	if dir != -1 && _player:
		match dir:
			Game.DIR4.UP:
				print("up")
				_player.move(_player.MoveDirection.UP)
			Game.DIR4.RIGHT:
				print("right")
				_player.move(_player.MoveDirection.RIGHT)
			Game.DIR4.DOWN:
				print("down")
				_player.move(_player.MoveDirection.DOWN)
			Game.DIR4.LEFT:
				print("left")
				_player.move(_player.MoveDirection.LEFT)

func _on_XToFocus_focus_changed(focus):
	if started:
		if focus:
			song_position = $music.get_playback_position()
			$timing.stop()
			$music.stop()
		else:
			$music.play(song_position)
			$timing.start(song_position + offset)
