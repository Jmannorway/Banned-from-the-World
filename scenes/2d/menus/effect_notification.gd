extends Control

signal notification_dismissed

func _ready():
	visible = false

func show_notification(effect_name : String):
	$background/text.set_effect_name(effect_name)
	visible = true

func _input(event: InputEvent) -> void:
	if visible && Input.is_action_just_pressed("interact"):
		visible = false
		emit_signal("notification_dismissed")
