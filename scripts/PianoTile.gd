extends CollisionShape2D

var direction: int setget set_direction

onready var tweenMove: Tween = $Tween

signal remove_key()

func _ready():
# warning-ignore:return_value_discarded
	tweenMove.connect("tween_all_completed", self, "ended_path")

func set_direction(var value: int) -> void:
	direction = value
	
	match direction:
		Direction.UP:
			rotation = -PI * 0.5
		Direction.LEFT:
			rotation = PI
		Direction.DOWN:
			rotation = PI * 0.5
		Direction.RIGHT:
			rotation = -PI * 0.5

func set_tile_direction(var tileDirection: int, var duration: float, var fromPosition: Vector2, var toPosition: Vector2) -> void:
	set_direction(tileDirection)
	
	position = fromPosition
	
# warning-ignore:return_value_discarded
	tweenMove.interpolate_property(self, "position", fromPosition, toPosition, duration)
# warning-ignore:return_value_discarded
	tweenMove.start()

# when reaching here, the player has missed this(self) piano tile
func ended_path() -> void:
	visible = false

enum Direction {
	UP,
	LEFT,
	DOWN,
	RIGHT
}
