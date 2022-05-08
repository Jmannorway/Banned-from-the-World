extends EffectState

export(SpriteFrames) var twirl_animation

func action():
	if get_behavior_state_name() == "player_idle" && !playing_animation:
		play_animation(twirl_animation, 1.5)
