extends Interactable2D

export(String, FILE, "*.tscn") var map_path
export var player_start_index = 0
export var on_step := false

func step():
	if on_step:
		MapManager.warp_to_map_by_path(map_path, player_start_index)

func interact():
	if !on_step:
		MapManager.warp_to_map_by_path(map_path, player_start_index)
