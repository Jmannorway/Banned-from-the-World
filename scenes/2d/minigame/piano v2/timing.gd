extends Node

export(bool) var play_metronome

var bpm : float
var denominator : float
var counting : bool

# Don't
var beat : int
var bar : int
var spawn_beat : int
var spawn_bar : int

signal rhythm(beat, bar)
signal bar(bar)
signal spawn_rhythm(beat, bar)
signal spawn_bar(bar)

func stop_all():
	for i in get_children():
		if i as Timer:
			i.stop()

func set_paused(val : bool):
	for i in get_children():
		if i as Timer:
			i.set_paused(val)

func set_timer(timer : Timer, wait_time : float, position : float):
	timer.start(fposmod(wait_time - position - 0.0001, wait_time) + 0.0001)
	timer.wait_time = wait_time

func seconds_to_bars(sec : float) -> float:
	return floor(sec / get_bar_rate())

func seconds_to_beats(sec : float) -> float:
	return floor(sec / get_rhythm_rate())

func print_counter():
	prints("Counter: { Bar:", bar, "Spawn bar:", spawn_bar, "Beat:", beat, "Spawn beat:", spawn_beat, "}")

func print_timers():
	prints(
		"Timers: {",
		"Bar:", $bar.time_left,
		"Spawn bar:", $spawn_bar.time_left,
		"Rhythm:", $rhythm.time_left,
		"Spawn rhythm:", $spawn_rhythm.time_left, "}")

func restart(_spawn_to_hit_duration : float = 0.0, _offset : float = 0.0):
	bar = seconds_to_bars(_offset)
	spawn_bar = seconds_to_bars(_offset + _spawn_to_hit_duration)
	beat = seconds_to_beats(_offset)
	spawn_beat = seconds_to_beats(_offset + _spawn_to_hit_duration)
	
	set_timer($bar, get_bar_rate(), _offset)
	set_timer($spawn_bar, get_bar_rate(), _offset + _spawn_to_hit_duration)
	set_timer($rhythm, get_rhythm_rate(), _offset)
	set_timer($spawn_rhythm, get_rhythm_rate(), _offset + _spawn_to_hit_duration)

func start(_bpm : float, _denominator : float, _spawn_to_hit_duration : float, _offset : float = 0.0):
	bpm = _bpm
	denominator = _denominator
	counting = true
	restart(_spawn_to_hit_duration, _offset)
#	$rhythm.start(_rhythm_rate)
#	$bar.start(_bar_rate)
#	$spawn_rhythm.start(wrapf(_rhythm_rate - _spawn_to_hit_duration, 0.0, _rhythm_rate))
#	$spawn_bar.start(wrapf(_bar_rate - _spawn_to_hit_duration, 0.0, _bar_rate))

# Gets the time between one rhythm and the next
func get_rhythm_rate() -> float:
	return 1.0 / (bpm / 60.0)

# Gets the time between one bar and the next
func get_bar_rate() -> float:
	return get_rhythm_rate() * denominator

func _increment_beat_count(val : int) -> int:
	return (val + 1) % int(denominator)

func _reset_count():
	beat = 0
	bar = 0
	spawn_beat = 0
	spawn_bar = 0

func _on_bar_timeout():
	emit_signal("bar", bar)
	bar += int(counting)

# Correct spawn bar time after having its first emmision
func _on_spawn_bar_timeout():
	emit_signal("spawn_bar", bar)
	spawn_bar += int(counting)

func _on_rhythm_timeout():
	if play_metronome:
		$metronome.play()
	if counting:
		beat = _increment_beat_count(beat)
	emit_signal("rhythm", beat, bar)

# Correct spawn rhythm time after having its first emmision
func _on_spawn_rhythm_timeout():
	emit_signal("spawn_rhythm", beat, bar)
	if counting:
		spawn_beat = _increment_beat_count(spawn_beat)
	print_counter()
