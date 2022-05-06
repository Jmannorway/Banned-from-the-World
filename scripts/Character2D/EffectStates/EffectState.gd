extends State

class_name EffectState

var player # Is of type Character2D (no static typing due to cyclic dependency)
export(SpriteFrames) var look # Sprite frames associated with the look of the effect

func init(_player):
	player = _player

# Change the player's sprite to the effect-assosiated look
func enter():
	player.sprite.frames = look

# New function that gets called by the player
func action():
	pass

func get_behavior_state_name() -> String:
	return player.behavior_state.get_current_state().name
