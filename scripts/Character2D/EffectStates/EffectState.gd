extends State

class_name EffectState

var player # Is of type Character2D (no static typing due to cyclic dependency)
export(SpriteFrames) var look # Sprite frames associated with the look of the effect

func init(_player):
	player = _player

# Change the player's sprite to the effect-assosiated look
func enter():
	player.sprite.frames = look
	playing_animation = false

# New function that gets called by the player
func action():
	pass

func get_behavior_state_name() -> String:
	return player.behavior_state.get_current_state().name



# Utility
var playing_animation : bool
func play_animation(ani : SpriteFrames, spd : float = 1.0):
	playing_animation = true
	player.set_frozen(name, true)
	player.sprite.frames = ani
	player.sprite.play()
	player.sprite.speed_scale = spd
	Util.connect_safe(player.sprite, "animation_finished", self, "reset_animation")

func reset_animation():
	playing_animation = false
	player.set_frozen(name, false)
	player.sprite.frames = look
	player.sprite.speed_scale = 1.0
	Util.disconnect_safe(player.sprite, "animation_finished", self, "reset_animation")
