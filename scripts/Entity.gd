extends Character2D

var checkpointDetectionThreashold: float = 18.0
var path: PoolVector2Array
var checkpointIndex: int

onready var tween: Tween = $move_animation_tween
onready var selfSprite: AnimatedSprite = $move_animation_tween.get_parent()

func _ready():
# warning-ignore:return_value_discarded
	tween.connect("tween_all_completed", self, "follow_path")

func _input(event):
	if Input.is_mouse_button_pressed(1) and event is InputEventMouseButton:
		new_follow_path(event.position)

func new_follow_path(var toPoint: Vector2) -> void:
	checkpointIndex = 0
	
	path = WorldGrid.navigation_grid.get_navigation_path(position, toPoint)
	
	if path.empty():
		printerr("The Enemy Path is empty. Make sure that you have selected a valid position.")
		return
	
	follow_path()

func desired_move_direction() -> Vector2:
	var _retDirection: Vector2 = Vector2.ZERO
	var _shortestDistance: float = INF
	var _compareDistance: float = Vector2(position + Vector2.RIGHT).distance_to(path[checkpointIndex])
	
	if _shortestDistance > _compareDistance and !check_solid_relative(Vector2.RIGHT):
		_retDirection = Vector2.RIGHT
		_shortestDistance = _compareDistance
	
	_compareDistance = Vector2(position + Vector2.UP).distance_to(path[checkpointIndex])
	
	if _shortestDistance > _compareDistance and !check_solid_relative(Vector2.UP):
		_retDirection = Vector2.UP
		_shortestDistance = _compareDistance
	
	_compareDistance = Vector2(position + Vector2.LEFT).distance_to(path[checkpointIndex])
	
	if _shortestDistance > _compareDistance and !check_solid_relative(Vector2.LEFT):
		_retDirection = Vector2.LEFT
		_shortestDistance = _compareDistance
	
	_compareDistance = Vector2(position + Vector2.DOWN).distance_to(path[checkpointIndex])
	
	if _shortestDistance > _compareDistance and !check_solid_relative(Vector2.DOWN):
		_retDirection = Vector2.DOWN
		_shortestDistance = _compareDistance
	
	selfSprite.offset = -_retDirection * Game.SNAP
# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "offset", null, Vector2.ZERO, move_cooldown_length, Tween.TRANS_LINEAR)
	
	return _retDirection

func follow_path() -> void:
	if checkpointIndex >= path.size():
# warning-ignore:return_value_discarded
		tween.remove_all()
# warning-ignore:return_value_discarded
		tween.stop_all()
		return
	
	move(desired_move_direction())
	
# warning-ignore:return_value_discarded
	tween.start()
	
	if has_reached_checkpoint():
		checkpointIndex += 1

func has_reached_checkpoint() -> bool:
	return position.distance_to(path[checkpointIndex]) <= checkpointDetectionThreashold

#########################
# OVERWRITTEN FUNCTIONS #
#########################

func move(var dir: Vector2) -> void:
	position += dir * Game.SNAP
