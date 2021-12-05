extends AudioStreamPlayer

func set_music(new_stream : AudioStream):
	if playing:
		stop()
	
	stream = new_stream
	play()
