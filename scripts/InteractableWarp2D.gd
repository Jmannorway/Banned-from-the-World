extends Interactable2D

export var map_name : PackedScene
export var player_start_index = 0

func step():
	pass

func interact():
	MapManager.warp_to_map(map_name, player_start_index)
