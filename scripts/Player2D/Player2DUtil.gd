class_name Player2DUtil

const PLAYER_2D_SCENE := preload("res://scenes/2d/character & player/player_2d.tscn")

static func instance_player_2d() -> Player2D:
	return PLAYER_2D_SCENE.instance() as Player2D
