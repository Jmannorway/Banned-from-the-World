extends Node

# Directional enums and arrays of vectors
enum DIR{
	UP_LEFT,
	UP,
	UP_RIGHT,
	MIDDLE_LEFT,
	MIDDLE,
	MIDDLE_RIGHT,
	DOWN_LEFT,
	DOWN
	DOWN_RIGHT,
	MAX}
enum DIR4{
	UP,
	RIGHT,
	DOWN,
	LEFT,
	MAX}
const VDIR4 = [
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT]
enum BDIR{
	UP_LEFT = 1,
	UP = 2,
	UP_RIGHT = 4,
	MIDDLE_LEFT = 8,
	MIDDLE = 16,
	MIDDLE_RIGHT = 32,
	DOWN_LEFT = 64,
	DOWN = 128,
	DOWN_RIGHT = 256,
	ALL = 511}
const VDIR = [
	Vector2(-1, -1),
	Vector2.UP,
	Vector2(1, -1),
	Vector2.LEFT,
	Vector2.ZERO,
	Vector2.RIGHT,
	Vector2(-1, 1),
	Vector2.DOWN,
	Vector2.ONE]

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
	randomize()
	VisualServer.set_default_clear_color(Color.black)
