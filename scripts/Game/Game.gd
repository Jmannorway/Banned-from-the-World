extends Node

const SNAP := 24
const DEBUG := true
const RESOLUTION_2D := Vector2(480, 360)
const RESOLUTION_3D := RESOLUTION_2D * 2

# TODO: Define what it means to go from outer to inner and vice versa
# For now we just call 
enum WORLD {OUTER, INNER}
var world = WORLD.OUTER setget set_world
signal world_changed

func set_world(val) -> void:
	world = val
	emit_signal("world_changed")

func _ready():
	VisualServer.set_default_clear_color(Color.black)
