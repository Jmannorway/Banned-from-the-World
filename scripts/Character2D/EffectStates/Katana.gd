extends EffectState

export(SpriteFrames) var fight_animation

func action():
	if get_behavior_state_name() == "player_idle" && !playing_animation:
		play_animation(fight_animation)

func exit():
	reset_animation()


