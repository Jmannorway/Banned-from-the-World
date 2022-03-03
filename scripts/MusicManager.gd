extends Node

onready var testTrack1: AudioStream = preload("res://audio/Neko To Sanpo.mp3")
onready var fadeTween: Tween = $fadeout

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		play_music(testTrack1)
	elif Input.is_action_just_pressed("move_down"):
		pause_music(0, true)

func _ready():
	fadeTween.connect("tween_completed", self, "on_fadeout_finished")

func play_music(var track: AudioStream, var trackIndex: int = -1) -> void:
	if trackIndex < 0:
		add_audio_player("music", track).play()
		return
	
	var _tracks: Array = $music.get_children()
	
	if _tracks.size() > trackIndex:
		var _streamPlayer: AudioStreamPlayer = _tracks[trackIndex]
		
		_streamPlayer.stop()
		_streamPlayer.stream = track
		_streamPlayer.play()

func play_ambience(var track: AudioStream, var trackIndex: int = -1) -> void:
	if trackIndex < 0:
		add_audio_player("ambience", track).play()
		return
	
	var _tracks: Array = $ambience.get_children()
	
	if _tracks.size() > trackIndex:
		var _streamPlayer: AudioStreamPlayer = _tracks[trackIndex]
		
		_streamPlayer.stop()
		_streamPlayer.stream_paused
		_streamPlayer.stream = track
		_streamPlayer.play()

func play_sound(var track: AudioStream) -> void:
	add_audio_player("sound", track).play()

func pause_music(var trackIndex: int, var paused: bool) -> void:
	$music.get_child(trackIndex).stream_paused = paused

func pause_ambience(var trackIndex: int, var paused: bool) -> void:
	$ambience.get_child(trackIndex).stream_paused = paused

func pause_sound(var trackIndex: int, var paused: bool) -> void:
	$sound.get_child(trackIndex).stream_paused = paused

func stop_music(var trackIndex: int) -> void:
	$music.get_child(trackIndex).stop()

func stop_ambience(var trackIndex: int) -> void:
	$ambience.get_child(trackIndex).stop()

func stop_sound(var trackIndex: int) -> void:
	$sounds.get_child(trackIndex).stop()

func clear_all() -> void:
	clear_music()
	clear_ambience()
	clear_sounds()

func clear_music() -> void:
	var _tracks: Array = $music.get_children()
	
	for streamPlayer in _tracks:
		streamPlayer.queue_free()

func clear_ambience() -> void:
	var _tracks: Array = $ambience.get_children()
	
	for streamPlayer in _tracks:
		streamPlayer.queue_free()

func clear_sounds() -> void:
	var _tracks: Array = $sounds.get_children()
	
	for streamPlayer in _tracks:
		streamPlayer.queue_free()

func add_audio_player(var key: String, var track: AudioStream) -> AudioStreamPlayer:
	var _newStreamPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
	
	get_node(key).add_child(_newStreamPlayer)
	_newStreamPlayer.stream = track
	_newStreamPlayer.bus = key
	
	return _newStreamPlayer

func on_fadeout_finished(var object: Object, var path: NodePath) -> void:
	pass
