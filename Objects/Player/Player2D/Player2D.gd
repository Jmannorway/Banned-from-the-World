extends KinematicBody2D

var speed = 100
onready var character_sprite = $AnimatedCharacterSprite

func get_input_vector() -> Vector2:
	return Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

func _physics_process(delta):
	var input_vector = get_input_vector()
	move_and_slide(input_vector.normalized() * speed)
	character_sprite.walk(input_vector)
