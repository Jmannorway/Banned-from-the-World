extends Node2D

class_name Room2D

# will not play music if left empty
export var room_music : AudioStream

func _enter_tree():
	if room_music:
		RoomMusic.set_music(room_music)
