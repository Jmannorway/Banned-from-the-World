extends Sprite

export var rotation_speed := 15

func _process(delta):
	rotation_degrees += rotation_speed * delta
