extends Particles2D

export(Statistics.CHECKPOINT) var checkpoint
const unlocked_color := Color.aqua
const locked_color := Color.red

func _ready():
	if checkpoint == Statistics.CHECKPOINT._MAX || Util.int_get_bit(Statistics.metadata.checkpoint, checkpoint):
		process_material.color = unlocked_color
	else:
		process_material.color = locked_color
