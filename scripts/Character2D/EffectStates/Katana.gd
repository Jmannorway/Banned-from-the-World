extends EffectState

export(SpriteFrames) var fight_animation
var swinging : bool setget set_swinging
func set_swinging(val : bool):
	player.set_frozen("slash_katana", val)
	swinging = val
	if val:
		player.sprite.frames = fight_animation
		player.sprite.play()
		Util.connect_safe(player.sprite, "animation_finished", self, "_on_sprite_animation_finished")
	else:
		player.sprite.frames = look
		Util.disconnect_safe(player.sprite, "animation_finished", self, "_on_sprite_animation_finished")

func action():
	if get_behavior_state_name() == "player_idle" && !swinging:
		set_swinging(true)

func _on_sprite_animation_finished():
	set_swinging(false)

func enter():
	.enter()

func exit():
	set_swinging(false)


