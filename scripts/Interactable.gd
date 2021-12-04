extends Area

class_name Interactable

var playerInsideEvent: bool = false

func _ready():
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_enter_body")
# warning-ignore:return_value_discarded
	connect("body_exited", self, "_on_exit_body")

# warning-ignore:unused_argument
func _input(event):
	if playerInsideEvent and Input.is_action_just_pressed("interact"):
		_event()

func _event() -> void:
	pass

func _on_enter_body(var body: Node) -> void:
	if body is CharacterController3D:
		playerInsideEvent = true

func _on_exit_body(var body: Node) -> void:
	if body is CharacterController3D:
		playerInsideEvent = false
