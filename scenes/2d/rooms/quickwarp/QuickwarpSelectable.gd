extends AnimatedSprite

export(Statistics.CHECKPOINT) var checkpoint

func _ready() -> void:
	if Util.int_get_bit(Statistics.metadata.checkpoint, checkpoint):
		animation = "lit"
		play()
	else:
		animation = "unlit"

func step():
	pass

func interact():
	pass
