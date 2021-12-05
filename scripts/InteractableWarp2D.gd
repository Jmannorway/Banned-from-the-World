extends Node2D

export var map_scene : PackedScene
export var player_start_index : int

func warp() -> void:
	Game.warp_to_map(map_scene, player_start_index)

func _on_interactable_2d_interacted():
	warp()
