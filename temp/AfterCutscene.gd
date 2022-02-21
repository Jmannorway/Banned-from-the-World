extends VideoPlayer

export var loadScene: PackedScene

func _ready():
	connect("finished", self, "load_scene")

func load_scene() -> void:
	get_tree().change_scene_to(loadScene)

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		load_scene()
