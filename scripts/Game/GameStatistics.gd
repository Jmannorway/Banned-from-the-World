extends Node

# This script handles:
# - What the player has unlocked
# - Current progress and such
#
# More can be added and referenced from this script since it is a Global Script

#class_name Statistics

const DEFAULT_METADATA := {
	"intro_finished" : false,
	"inner_world_travel_count" : 0,
	"unlocked_effects" : {},
	"fog_stage" : 0,
	"checkpoint" : 0,
	"minigame_clears" : 0,
	"world" : "dream_world", # doesn't do anything, only a proof of concept
	"room" : "bedroom",
	"position" : Vector3.ZERO 
}
static func create_new_game_metadata() -> Dictionary:
	var _new = DEFAULT_METADATA.duplicate(true)
	_new.unlocked_effects = Player2D.create_effects_dictionary(false)
	_new.unlocked_effects.normal = true
	return _new
var metadata : Dictionary

enum CHECKPOINT {
	NORTH,
	WEST,
	EAST,
	SOUTH,
	_MAX
}

enum MINIGAME {
	PIANO = 1,
	DOORS = 2,
	INTROSPECTION = 4,
	_QUESTIONMARK_ = 8,
	_ALL = 15
}

# In the future we can store this file externally
# instead of res:// we use user:// (%appdata%, local directory)
const DATA_PATH: String = "res://data/"
const DATA_FILE: String = "statistics.dat"

func _init():
	metadata = read_meta_file()

func read_meta_file() -> Dictionary:
	var _file: File = File.new()
	
	if _file.open(DATA_FILE, _file.READ) != OK:
		_file.close()
		print("GameStatistics: Created new game dictionary")
		return create_new_game_metadata()
	
	print("GameStatistics: Read meta file")
	var _meta : Dictionary = str2var(_file.get_as_text()) 	
	_file.close()
	
	return _meta

func write_meta_file() -> void:
	var _file: File = File.new()
	print("GameStatistics: Save written")
	if _file.open(DATA_FILE, _file.WRITE) == OK:
		_file.store_string(var2str(metadata))
		_file.close()

func _exit_tree():
	write_meta_file()
