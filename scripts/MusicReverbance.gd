extends Node2D

export var musicToPlay: AudioStream
export var maxDistance: float = 20.0

# TODO: TODO TODO TODO TODO TODO TODO TODO
var superStupidWorkaroundToFixMusic := 2

onready var reverbEffectRef: AudioEffectReverb = AudioServer.get_bus_effect(1, 0)

func _ready():
	play_music()
	Util.connect_safe(MapManager, "map_changed", self, "_on_MapManager_map_changed")

func _on_MapManager_map_changed(n):
	superStupidWorkaroundToFixMusic -= 1
	if superStupidWorkaroundToFixMusic <= 0:
		MusicManager.clear_music()

# warning-ignore:unused_argument
func _process(delta):
	update_reverb()

func play_music() -> void:
	MusicManager.play_music(musicToPlay)
	set_process(true)

func update_reverb() -> void:
	var _value: float = PlayerAccess.get_player_2d(get_tree()).global_position.distance_to(global_position) / maxDistance
	
	_value = clamp(_value, 0.0, 1.0)
	
	reverbEffectRef.wet = lerp(0.1, 0.23, 1.0 - _value)
	reverbEffectRef.dry = lerp(0.0, 0.22, 1.0 - _value)
	
#	print("wet - ", reverbEffectRef.wet, " dry - ", reverbEffectRef.dry)
