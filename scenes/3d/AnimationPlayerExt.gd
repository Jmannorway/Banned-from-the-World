extends AnimationPlayer

export(String) var starting_animation
export(bool) var start_on_ready
export(Array, String) var animation_sequence
export(bool) var queue_sequence
export(float, 1.0, 4.0) var skip_distance = 4.0

func _ready():
	if start_on_ready:
		play(starting_animation)
	if queue_sequence:
		for ani in animation_sequence:
			queue(ani)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if is_playing():
			advance(skip_distance)
