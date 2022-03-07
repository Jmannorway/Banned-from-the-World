extends Node

# This script handles:
# - What the player has unlocked
# - Current progress and such
#
# More can be added and referenced from this script since it is a Global Script

#class_name Statistics

const DEFAULT_METADATA := {
	"inner_world_travel_count" : 0,
	"fog_stage" : 0,
	"checkpoint" : 0,
	"minigame_clears" : 0,
	"world" : "dream_world", # doesn't do anything, only a proof of concept
	"room" : "bedroom",
	"position" : Vector3.ZERO 
}
var metadata := DEFAULT_METADATA

enum CHECKPOINT {
	NORTH = 1,
	WEST = 2,
	EAST = 4,
	SOUTH = 8,
	_ALL = 15
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

func _enter_tree():
	metadata = read_meta_file()

func read_meta_file() -> Dictionary:
	var _file: File = File.new()
	
	if _file.open(DATA_PATH + DATA_FILE, _file.READ) != OK:
		_file.close()
		
		return DEFAULT_METADATA
	
	var _meta: Dictionary = _file.get_var()
	_file.close()
	
	return _meta

func write_meta_file() -> void:
	var _file: File = File.new()
	
	if _file.open(DATA_PATH + DATA_FILE, _file.WRITE) == OK:
		_file.store_var(metadata)
		_file.close()

func _exit_tree():
	write_meta_file()
