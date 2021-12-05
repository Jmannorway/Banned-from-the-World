extends Node

var player_start_index := 0
var player_2d := load("res://scenes/2d/player/player_2d.tscn")

func _enter_tree():
	pass

func warp_to_map(map : PackedScene, psi : int = 0) -> void:
	get_tree().change_scene_to(map)
	player_start_index = psi

func instance_player_2d() -> Player2D:
	if player_2d:
		return player_2d.instance()
	else:
		return null
