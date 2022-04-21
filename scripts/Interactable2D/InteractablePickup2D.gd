extends Interactable2D

export(String) var effect

func update_visibility() -> void:
	visible = !Statistics.metadata.unlocked_effects[effect]

func _ready() -> void:
	update_visibility()

func step():
	pass

func interact():
	if !Statistics.metadata.unlocked_effects[effect]:
		Statistics.metadata.unlocked_effects[effect] = true
		# function visibly unlocking the effect
		update_visibility()
		print("Effect '", effect, "' unlocked!")
