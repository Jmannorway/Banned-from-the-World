extends Area

class_name Interactable

var playerInsideEvent: bool = false

func _ready():
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_enter_body")
# warning-ignore:return_value_discarded
	connect("body_exited", self, "_on_exit_body")

# warning-ignore:unused_argument
func _event(var player: CharacterController3D) -> void:
	pass

func _on_enter_body(var body: Node) -> void:
	if body is CharacterController3D:
# warning-ignore:return_value_discarded
		body.connect("action_event", self, "_event")

func _on_exit_body(var body: Node) -> void:
	if body is CharacterController3D:
		body.disconnect("action_event", self, "_event")
