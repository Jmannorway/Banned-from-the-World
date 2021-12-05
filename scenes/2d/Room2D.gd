extends Area2D

class_name Room2D

export var room_music : AudioStream

func _enter_tree():
	if room_music:
		RoomMusic.set_music(room_music)
