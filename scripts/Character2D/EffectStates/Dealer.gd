extends EffectState

func action():
	MapManager.viewport_sprite.set_next_effect()

func exit():
	MapManager.viewport_sprite.set_effect(0)
