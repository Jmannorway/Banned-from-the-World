extends Node2D

export var floorsPath: NodePath
export var stairsPath: NodePath

var currentFloor: int setget set_floor

onready var floors: Array = get_node(floorsPath).get_children()
onready var staircases: Array = get_node(stairsPath).get_children()

signal changed_floor(floorIndex)

func _ready():
	for stair in staircases:
		stair.connect("change_floors", self, "set_relative_floor")
	
	set_floor(0)

func set_floor(var index: int) -> void:
	if index < 0:
		return
	
	currentFloor = index
	
#	print(currentFloor)
	
	floors[currentFloor].get_node("solid_grid_2d").paint_to_world_grid()
	
	emit_signal("changed_floor", currentFloor)

func set_relative_floor(var elevation: int) -> void:
	set_floor(currentFloor + elevation)
