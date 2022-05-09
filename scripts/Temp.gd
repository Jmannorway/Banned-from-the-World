extends Node

class_name Temp

# TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP

static func goto_world(tree : SceneTree, world : int) -> void:
	Game.set_world(world)
	MusicManager.clear_music()
	
	if world == Game.WORLD.OUTER:
		# Clear 2d world
		MapManager.clear_map()
		# Load default 3d world
		tree.change_scene("res://scenes/3d/real_world.tscn")
	else:
		# Load 2d scene
		if Statistics.metadata.checkpoint == 0:
			tree.change_scene("res://scenes/empty.tscn")
			MapManager.warp_to_map_by_path("res://scenes/2d/maps/phase_2_map.tscn")
		else:
			tree.change_scene("res://scenes/2d/quickwarp/Quickwarp.tscn")

# TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP
