extends Sprite

onready var tween := $animation_tween

export(float, 0.1, 16.0) var final_size = 4.0
export(float) var diffuse_duration = 1.0

onready var initial_scale = scale
onready var initial_alpha = modulate.a

func _ready():
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("debug_test"):
		diffuse()

func diffuse():
	visible = true
	tween.interpolate_property(self, "modulate:a", initial_alpha, 0.0, diffuse_duration)
	tween.interpolate_property(self, "scale", initial_scale, Vector2.ONE * final_size, diffuse_duration)
	tween.start()

func _on_animation_tween_tween_all_completed():
	visible = false
