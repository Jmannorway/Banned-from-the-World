tool
extends Room2D

export var elevation: int setget set_elevation
export var isOpen: bool setget open_elevator

onready var anim: AnimationPlayer = $AnimationPlayer

func open_elevator(var status: bool) -> void:
	var _oldOpen: bool = isOpen
	
	if _oldOpen == status or anim == null:
		return
	
	isOpen = status
	
	if status and anim:
		anim.play("Doors")
	else:
		anim.play_backwards("Doors")

func set_elevation(var value: int) -> void:
	elevation = value
	
	$elevation_numbers/number.frame = int(elevation) % 10
	$elevation_numbers/number2.frame = int(elevation * 0.1) % 10
	$elevation_numbers/number3.frame = int(elevation * 0.01) % 10
