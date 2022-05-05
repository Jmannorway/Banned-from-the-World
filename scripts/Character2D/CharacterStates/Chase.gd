extends CharacterState

var checkpointDetectionThreshold: float = 18.0
var path: PoolVector2Array
var checkpointIndex: int
export(PackedScene) var penaltyMap
export(float) var path_refresh_interval = 1.9
var timer : SceneTreeTimer
var try_chase : bool = false
export(float, 32) var target_distance_threshold : float

func enter():
	var _player = Util.get_first_node_in_group(get_tree(), "player_2d")
	if _player:
		new_follow_path(_player.global_position)
		print("new follow path", path, checkpointIndex)

func process(delta : float) -> String:
	if path.empty() || checkpointIndex >= path.size():
		return "wait"
	
	while checkpointIndex < path.size() && has_reached_checkpoint():
		checkpointIndex += 1
	
	if checkpointIndex >= path.size():
		return "wait"
	
	var _move = desired_move_direction()
	character.queue_move(_move)
	print(_move)
	return "move"

func check_for_player():
	if ($interactable_detector_2d.get_facing_interactable(self, Vector2.LEFT) ||
		$interactable_detector_2d.get_facing_interactable(self, Vector2.RIGHT) ||
		$interactable_detector_2d.get_facing_interactable(self, Vector2.DOWN) ||
		$interactable_detector_2d.get_facing_interactable(self, Vector2.UP)):
		MapManager.warp_to_map(penaltyMap)

func new_follow_path(var toPoint: Vector2) -> void:
	checkpointIndex = 0
	
	path = WorldGrid.get_navigation_grid(character.layer).get_navigation_path(character.global_position, toPoint)
	
	if path.empty():
		printerr("The Enemy Path is empty. Make sure that you have selected a valid position.")
		return

func has_reached_checkpoint() -> bool:
	return character.position.distance_to(path[checkpointIndex]) <= checkpointDetectionThreshold

func desired_move_direction() -> Vector2:
	var _retDirection: Vector2 = Vector2.ZERO
	var _shortestDistance: float = INF
	var _position = character.position
	var _compareDistance: float = Vector2(_position + Vector2.RIGHT).distance_to(path[checkpointIndex])
	
	if _shortestDistance > _compareDistance and !character.check_solid_relative(Vector2.RIGHT):
		_retDirection = Vector2.RIGHT
		_shortestDistance = _compareDistance
	
	_compareDistance = Vector2(_position + Vector2.UP).distance_to(path[checkpointIndex])
	
	if _shortestDistance > _compareDistance and !character.check_solid_relative(Vector2.UP):
		_retDirection = Vector2.UP
		_shortestDistance = _compareDistance
	
	_compareDistance = Vector2(_position + Vector2.LEFT).distance_to(path[checkpointIndex])
	
	if _shortestDistance > _compareDistance and !character.check_solid_relative(Vector2.LEFT):
		_retDirection = Vector2.LEFT
		_shortestDistance = _compareDistance
	
	_compareDistance = Vector2(_position + Vector2.DOWN).distance_to(path[checkpointIndex])
	
	if _shortestDistance > _compareDistance and !character.check_solid_relative(Vector2.DOWN):
		_retDirection = Vector2.DOWN
		_shortestDistance = _compareDistance
	
	return _retDirection
