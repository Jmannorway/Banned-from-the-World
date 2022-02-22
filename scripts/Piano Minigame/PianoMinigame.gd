extends Node2D

export var scoreByDistance: PoolRealArray
export var songPatterns: Array

onready var breakTimer: Timer = $break_timer
onready var tween: Tween = $tween_rotation
onready var keyPad: Node2D = $directional_sprite

var pattern: SongPattern

var attemtps: int
var currentWalkDirection: int
var currentPattern: int
var currentScore: int
var currentCombination: PoolIntArray
var currentCorrectCombo: PoolIntArray

signal score_appended(score)
signal minigame_started
signal minigame_ended
signal pattern_ended

func _ready():
# warning-ignore:return_value_discarded
	$spawner.connect("pattern_end", self, "end_pattern")
# warning-ignore:return_value_discarded
	tween.connect("tween_all_completed", self, "after_rotation")
# warning-ignore:return_value_discarded
	breakTimer.connect("timeout", self, "play_pattern")
# warning-ignore:return_value_discarded
	XToFocus.connect("focus_changed", self, "focusing")

func start_song() -> void:
	currentPattern = 0
	
	emit_signal("minigame_started")
	
	play_pattern()

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		start_song()
		set_process_input(false)

func generate_random_pattern() -> void:
	pattern = SongPattern.new()
	
	pattern.maxWalkDirection = randi() % 4
	
	pattern.pattern.append({"direction":randi() % 4, "duration":2.0, "note_length":1.0})
	pattern.pattern.append({"direction":randi() % 4, "duration":2.0, "note_length":1.0})
	pattern.pattern.append({"direction":randi() % 4, "duration":2.0, "note_length":1.0})
	pattern.pattern.append({"direction":randi() % 4, "duration":2.0, "note_length":1.0})

func change_orientation(var direction: int) -> void:
	currentWalkDirection = direction
	
	match direction:
		Direction.UP:
# warning-ignore:return_value_discarded
			tween.interpolate_property(keyPad, "rotation_degrees", null, 0, 1.4)
		Direction.LEFT:
# warning-ignore:return_value_discarded
			tween.interpolate_property(keyPad, "rotation_degrees", null, 270, 1.4)
		Direction.DOWN:
# warning-ignore:return_value_discarded
			tween.interpolate_property(keyPad, "rotation_degrees", null, 180, 1.4)
		Direction.RIGHT:
# warning-ignore:return_value_discarded
			tween.interpolate_property(keyPad, "rotation_degrees", null, 90, 1.4)
	
# warning-ignore:return_value_discarded
	tween.start()

func play_pattern() -> void:
	currentScore = 0
	attemtps += 1
	
	if attemtps >= 5:
		emit_signal("minigame_ended")
		print("We died")
		queue_free()
		return
	
	# replace with a collision thing from 3d world
	if PlayerAccess.get_player_3d(get_tree()).check_minigame_event():
		emit_signal("minigame_ended")
		print("minigame done")
		return
	
	XToFocus.enable_input(false)
	
	generate_random_pattern()
	
	change_orientation(pattern.maxWalkDirection)

func after_rotation() -> void:
	currentCombination.resize(0)
	currentCorrectCombo.resize(0)
	$spawner.start_pattern(pattern)

func end_pattern() -> void:
	var _direction: int = check_right_combo()
	
	if _direction >= 0:
		XToFocus.enable_input(true)
		
		attemtps = 0
		currentPattern += 1
		pattern = null
		
		PlayerAccess.get_player_3d(get_tree()).move(_direction + currentWalkDirection)
		
		breakTimer.start(5.0)
		emit_signal("pattern_ended")
		return
	
	play_pattern()

func push(var index: int) -> void:
	currentCorrectCombo.append(index)

func check_right_combo() -> int:
	if currentCombination.size() == currentCorrectCombo.size():
		for i in 4:
			var _comboMatch: bool
			
			for j in currentCorrectCombo.size():
				if currentCombination[j] != (currentCorrectCombo[j] + i) % 4:
					_comboMatch = false
					break
				
				_comboMatch = true
			
			if _comboMatch:
				return i
	
	return -1

# warning-ignore:unused_argument
func punching_key(var direction: int, var distance: float) -> void:
	currentCombination.append(direction)
#	append_score(distance)

func append_score(var distance: float) -> void:
	var _score: int # 0 is the worst score
	
	for i in scoreByDistance.size():
		if scoreByDistance[i] >= distance:
# warning-ignore:narrowing_conversion
			_score = abs(i - scoreByDistance.size())
			break
	
	currentScore += _score
	emit_signal("score_appended", _score)

func focusing(var focus: bool) -> void:
	breakTimer.paused = focus

enum Direction {
	UP,
	LEFT,
	DOWN,
	RIGHT
}
