tool
extends Resource

export var bpm: int = 140
export var tempo: int = 4
export var editable: bool
export var passablePoints: int = 4
export (int, "Up", "Down", "Left", "Right")var maxWalkDirection: int
export var pattern: Array setget set_pattern

var bps: float = 60.0 / float(bpm)
var segmentInSeconds: float = bps * 4.0

func set_pattern(var array: Array) -> void:
	if !editable:
		pattern = array
		return 
	
	if (pattern.empty() and array.empty()) or pattern.size() > array.size():
		pattern = array
		return
	
	while pattern.size() < array.size():
		# direction is the arrow direction
		# orientation is chanching the controls
		# duration is related to how fast the tile moves (in seconds)
		# note_length relates to the time between this note and the next note (a value of 1.0 = bps)
		pattern.push_back({"direction":0, "duration":2.0, "note_length":1.0})

func get_next_note_time(var index: int) -> float:
	return pattern[index]["note_length"] * bps
