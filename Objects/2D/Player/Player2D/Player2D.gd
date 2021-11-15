extends KinematicBody2D

var base = PlayerBase.new()
onready var sprite = $AnimatedCharacterSprite
onready var movement = $CharacterMovement
var interactables : Array

func is_facing(pos : Vector2) -> bool:
	return (pos - position).normalized().dot(Util.v3tov2(base.direction)) == 1

func find_facing_interactable() -> Area2D:
	for i in interactables:
		if is_facing(i.position):
			return i
	return null

func _process(delta):
	if not movement.is_moving() && Input.is_action_just_pressed("ui_accept"):
		var _interactable = find_facing_interactable()
		if _interactable:
			_interactable.interact()

func _physics_process(delta):
	var _input_vector = PlayerStatics.get_input_vector_2d()
	var _try_move = snap_to_player_grid(position + _input_vector * Vector2(base.grid.x, base.grid.y)) - position
	if not movement.is_moving():
		if (_input_vector.x != 0 || _input_vector.y != 0) && !test_move(transform, _try_move):
			movement.move_2d(_try_move, base.speed)
			sprite.walk(_input_vector)
			base.direction = Util.v2tov3(sprite.current_direction)
		else:
			sprite.idle()
	
	move_and_collide(movement.get_position_delta_2d())

func snap_to_player_grid(v : Vector2) -> Vector2:
	return Util.snap(v, Vector2(base.grid.x, base.grid.y), Vector2(base.offset.x, base.offset.y))

func _on_InteractableDetector_area_entered(area):
	interactables.push_back(area)
	print(area)

func _on_InteractableDetector_area_exited(area):
	var _ind = interactables.find(area)
	if _ind != -1:
		interactables.remove(_ind)
