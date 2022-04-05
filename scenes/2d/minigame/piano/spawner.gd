tool

extends Node2D

class_name PianoMinigameSpawner

func set_modulate(val : Color):
	modulate = val
	update()

export(Texture) var spawner_texture setget set_spawner_texture
func set_spawner_texture(new_spawner_texture : Texture):
	spawner_texture = new_spawner_texture
	update()

export(float, 64.0, 224.0) var spawn_distance = 160.0 setget set_spawn_distance
func set_spawn_distance(new_spawn_distance : float):
	spawn_distance = new_spawn_distance
	update()

enum STATE{NONE = -1, IDLE, SPAWNING, PAUSED}
export(STATE) var state setget _set_state
func _set_state(val : int):
	if state != val:
		emit_signal("changed_state", val)
	
	state = val
	match state:
		STATE.IDLE:
			pass
			print("spawner: idle")
		STATE.SPAWNING:
			bar_count = spawn_bars
			sequence.clear()
			print("spawner: spawning")
		STATE.PAUSED:
			bar_count = pause_bars
			print("spawner: paused")

export(PackedScene) var note
export(int, 1, 8) var pause_bars = 1
export(int, 1, 8) var spawn_bars = 1
export(Color) var ghost_color

var bar_count : int
var speed := 0.0
var queued_state : int
var sequence : Array
var ghost_direction : int = -1

signal changed_state(state)

func _process(delta):
	update()

func _draw():
	if Engine.editor_hint && spawner_texture:
		for i in Game.DIR4.MAX:
			var _texture_size = Vector2(spawner_texture.get_width(), spawner_texture.get_height())
			draw_texture(spawner_texture, Game.VDIR4[i] * spawn_distance - _texture_size / 2.0, modulate)
	
	if ghost_direction != -1:
		for _n in get_tree().get_nodes_in_group("notes"):
			var _tex = _n.get_node("note").texture
			draw_texture(
				_tex,
				_n.position.rotated(deg2rad(ghost_direction * 90)) - _tex.get_size() / 2,
				ghost_color)

func get_spawn_position(dir : int) -> Vector2:
	return Game.VDIR4[dir] * spawn_distance

func queue_state(_state : int):
	queued_state = _state

func queued_state_is_handled() -> bool:
	return queued_state == STATE.NONE

# Internal utility
func _spawn_note(from_dir : int):
	var _note = note.instance()
	_note.position = get_spawn_position(from_dir)
	_note.direction = (from_dir + 2) % Game.DIR4.MAX
	_note.speed = speed
	sequence.push_back(from_dir)
	add_child(_note)

func _spawn_random_note():
	_spawn_note(randi() % Game.DIR4.MAX)

func _handle_queued_state():
	if queued_state != STATE.NONE:
		_set_state(queued_state)
		queued_state = STATE.NONE

# Callbacks
func _on_timing_spawn_bar(bar):
	if !queued_state_is_handled():
		_handle_queued_state()
	else:
		match state:
			STATE.SPAWNING:
				bar_count -= 1
				if bar_count <= 0 && spawn_bars != -1:
					_set_state(STATE.PAUSED)
			STATE.PAUSED:
				bar_count -= 1
				if bar_count <= 0 && pause_bars != -1:
					_set_state(STATE.SPAWNING)

func _on_timing_spawn_rhythm(beat, bar):
	if bar == 1 && !queued_state_is_handled():
		_handle_queued_state()
	
	match state:
		STATE.SPAWNING:
			_spawn_random_note()
