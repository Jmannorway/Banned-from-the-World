tool
extends Area2D

export var song: Resource

export var upSpawner: Vector2 setget set_up
export var downSpawner: Vector2 setget set_down
export var leftSpawner: Vector2 setget set_left
export var rightSpawner: Vector2 setget set_right

var spawnIndex: int
var currentPatternTime: float

onready var pianoTile: PackedScene = load("res://scenes/2d/arrow_tile.tscn")
onready var timer: Timer = $timer

func _ready():
	if Engine.editor_hint:
		return
	
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "set_up_next_spawn")
	
	start_pattern_spawning()

func set_up(var value: Vector2) -> void:
	upSpawner = value
	
	if Engine.editor_hint:
		update()

func set_down(var value: Vector2) -> void:
	downSpawner = value
	
	if Engine.editor_hint:
		update()

func set_left(var value: Vector2) -> void:
	leftSpawner = value
	
	if Engine.editor_hint:
		update()

func set_right(var value: Vector2) -> void:
	rightSpawner = value
	
	if Engine.editor_hint:
		update()

func _draw():
	draw_circle(upSpawner, 2.0, Color.red)
	draw_circle(downSpawner, 2.0, Color.yellow)
	draw_circle(leftSpawner, 2.0, Color.lime)
	draw_circle(rightSpawner, 2.0, Color.blue)

func start_pattern_spawning() -> void:
	spawnIndex = 0
	currentPatternTime = 0.0
	
	set_up_next_spawn()

func get_spawn_position(var index: int) -> Vector2:
	match index:
		0:
			return upSpawner
		1:
			return downSpawner
		2:
			return leftSpawner
		3:
			return rightSpawner
	
	return Vector2.ZERO

func set_up_next_spawn() -> void:
	if spawnIndex >= song.pattern.size():
		timer.stop()
		return
	
	var _pianoTileInstance = pianoTile.instance()
	add_child(_pianoTileInstance)
	_pianoTileInstance.set_tile_direction(song.pattern[spawnIndex]["direction"], song.pattern[spawnIndex]["duration"], get_spawn_position(spawnIndex), Vector2.ZERO)
	
	var _nextTime: float = song.get_next_note_time(spawnIndex)
	
	if _nextTime <= 0.0:
		set_up_next_spawn()
	else:
		timer.start(_nextTime)
	
	spawnIndex += 1
