extends Interactable

signal interacted

func _interact(room_manager) -> void:
	emit_signal("interacted")
