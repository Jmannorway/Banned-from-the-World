extends Sprite

export var index := 0
export var location_name : String
const INVALID_PLAYER_START_INDEX = -37

func _enter_tree():
	if Game.player_start_index == index && Game.player:
		get_parent().add_child(Game.player.instance())
		Game.player_start_index = INVALID_PLAYER_START_INDEX
