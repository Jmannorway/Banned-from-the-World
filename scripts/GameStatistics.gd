extends Node

# This script handles:
# - What the player has unlocked
# - Current progress and such
#
# More can be added and referenced from this script since it is a Global Script

#class_name Statistics

var metadata: Dictionary

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
		
		return get_default_meta()
	
	var _meta: Dictionary = _file.get_var()
	_file.close()
	
	return _meta

func write_meta_file() -> void:
	var _file: File = File.new()
	
	_file.open(DATA_PATH + DATA_FILE, _file.WRITE)
	_file.store_var(metadata)
	_file.close()

func _exit_tree():
	write_meta_file()

static func get_default_meta() -> Dictionary:
	return {
		"fog_stage":0,
		"world":"dream_world", # doesn't do anything, only a proof of concept
		"room":"bedroom",
		"position":Vector3.ZERO 
	}
