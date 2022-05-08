extends EffectState

const GHOST_ALPHA = 0.5

func action():
	player.modulate.a = GHOST_ALPHA if player.modulate.a == 1.0 else 1.0

func exit():
	player.modulate.a = 1.0
