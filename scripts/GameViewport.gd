extends Viewport

class_name GameViewport

enum MODE {TWO_DIMENSIONAL, THREE_DIMENSIONAL}
var mode = MODE.TWO_DIMENSIONAL setget set_mode

func set_mode(val):
	mode = val
	
	if mode == MODE.TWO_DIMENSIONAL:
		size = Game.RESOLUTION_2D
		usage = USAGE_2D
	else:
		size = Game.RESOLUTION_3D
		usage = USAGE_3D
