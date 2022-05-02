extends Node

export(AudioStream) var song
enum Player {MUSIC, AMBIENCE}
export(Player) var player

func _ready() -> void:
	match player:
		Player.MUSIC:
			MusicManager.clear_music()
			MusicManager.play_music(song)
		Player.AMBIENCE:
			MusicManager.clear_ambience()
			MusicManager.play_ambience(song)
