tool

extends Node2D

const DIRECTORY = "res://Levels/"
const POSTFIX = ".tscn"
export var level_name : String
export var loaded : bool setget set_loaded
export var instanced : bool setget set_instanced
var instance : Node
var level : PackedScene

func get_level_path() -> String:
	return DIRECTORY + level_name + POSTFIX

func load_level() -> Resource:
	var _path = get_level_path()
	if ResourceLoader.exists(_path):
		return load(_path)
	else:
		print("Warning: Level does not exist")
		return null

func level_is_loaded() -> bool:
	return level != null

func level_is_instanced() -> bool:
	return is_instance_valid(instance)

func set_instanced(val : bool) -> void:
	if val:
		if level_is_loaded():
			instanced = val
			instance = level.instance()
			add_child(instance)
		else:
			print("Warning: Level wasn't loaded")
	elif level_is_instanced():
		instanced = val
		instance.queue_free()
		instance = null

func set_loaded(val : bool) -> void:
	if val:
		level = load_level()
		loaded = level != null
	else:
		level = null
		loaded = false

func _ready():
	load_level()
