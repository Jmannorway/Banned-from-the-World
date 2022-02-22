tool
extends Area2D

export var upSpawner: Vector2 setget set_up
export var downSpawner: Vector2 setget set_down
export var leftSpawner: Vector2 setget set_left
export var rightSpawner: Vector2 setget set_right

var spawnIndex: int
var pattern: SongPattern
var finalKey: Node

onready var pianoTile: PackedScene = load("res://scenes/2d/minigame/arrow_tile.tscn")
onready var timer: Timer = $timer

signal pattern_end

func _ready():
	if Engine.editor_hint:
		return
	
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "set_up_next_spawn")

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

func start_pattern(var newPattern: SongPattern) -> void:
	spawnIndex = 0
	
	pattern = newPattern
	
	set_up_next_spawn()

func get_spawn_position(var index: int) -> Vector2:
	if index < 0 or index >= 4:
		index = randi() % 4
	
	get_parent().push(index)
	
	match index:
		Direction.UP:
			return upSpawner
		Direction.LEFT:
			return leftSpawner
		Direction.DOWN:
			return downSpawner
		Direction.RIGHT:
			return rightSpawner
	
	return Vector2.ZERO

func final_key_punch() -> void:
	emit_signal("pattern_end")

func set_up_next_spawn() -> void:
	var _pianoTileInstance = pianoTile.instance()
	add_child(_pianoTileInstance)
	_pianoTileInstance.set_tile_direction(pattern.pattern[spawnIndex]["direction"], pattern.pattern[spawnIndex]["duration"], get_spawn_position(pattern.pattern[spawnIndex]["direction"]), Vector2.ZERO)
	
	var _nextTime: float = pattern.get_next_note_time(spawnIndex)
	if _nextTime <= 0.0:
		set_up_next_spawn()
	else:
		timer.start(_nextTime)
	
	spawnIndex += 1
	
	if spawnIndex >= pattern.pattern.size():
		_pianoTileInstance.connect("remove_key", self, "final_key_punch")
		timer.stop()

enum Direction {
	UP,
	LEFT,
	DOWN,
	RIGHT
}
