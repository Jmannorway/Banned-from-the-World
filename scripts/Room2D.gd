extends Area2D

class_name Room2D

# if left empty then it gets the node name
export var room_name : String
# will not st music if left empty
export var room_music : AudioStream

func _enter_tree():
	if room_name.empty():
		room_name = name
	
	if room_music:
		RoomMusic.set_music(room_music)
