extends CollisionShape2D

export var activeColor: Color = Color.white
export (int, "Up", "Left", "Down", "Right")var direction: int

const pointThreashold: float = 24.0
const disabledColor: Color = Color(0.4, 0.4, 0.4)
const directionNames: Array = [ "up", "left", "down", "right" ]

func _ready():
	modulate = disabledColor

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("move_" + directionNames[direction]):
		modulate = activeColor
		punch_key()
	elif Input.is_action_just_released("move_" + directionNames[direction]):
		modulate = disabledColor

func punch_key() -> void:
	if get_parent().keysInScope.empty():
		return
	
	var _firstKey: CollisionShape2D = get_parent().keysInScope[0]
	get_parent().keysInScope.remove(0)
	
	_firstKey.visible = false
	
	get_parent().get_parent().punching_key(direction, global_position.distance_to(_firstKey.global_position))
	_firstKey.emit_signal("remove_key")
