extends Character2D

var checkpointDetectionThreshold: float = 18.0
var path: PoolVector2Array
var checkpointIndex: int
export(PackedScene) var penaltyMap

func _ready():
	Util.connect_safe(self, "move_finished", self, "follow_path")
	Util.connect_safe(self, "move_finished", self, "check_for_player")
	chase_player()

func chase_player():
	if PlayerAccess.player_2d_exists(get_tree()):
		new_follow_path(PlayerAccess.get_player_2d(get_tree()).global_position)

func check_for_player():
	if ($interactable_detector_2d.get_facing_interactable(self, Vector2.LEFT) ||
		$interactable_detector_2d.get_facing_interactable(self, Vector2.RIGHT) ||
		$interactable_detector_2d.get_facing_interactable(self, Vector2.DOWN) ||
		$interactable_detector_2d.get_facing_interactable(self, Vector2.UP)):
		MapManager.warp_to_map(penaltyMap)

func new_follow_path(var toPoint: Vector2) -> void:
	checkpointIndex = 0
	
	path = WorldGrid.get_navigation_grid(layer).get_navigation_path(global_position, toPoint)
	
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
	
	return _retDirection

func follow_path() -> void:
	if checkpointIndex >= path.size():
		return
	
	queue_move(desired_move_direction())
	
	if has_reached_checkpoint():
		checkpointIndex += 1

func has_reached_checkpoint() -> bool:
	return position.distance_to(path[checkpointIndex]) <= checkpointDetectionThreshold

func _on_path_update_interval_timeout():
	chase_player()
