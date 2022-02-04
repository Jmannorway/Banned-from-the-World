extends ResourceGridBase2D

export(Array) var sounds
export(Resource) var default_sound

func get_sound_at_pixel(gpos : Vector2) -> AudioStreamSample:
	var _tile_id = get_cell(Util.snap_v2(gpos, Game.SNAP) / Game.SNAP)
	if _tile_id >= 0 && _tile_id < sounds.size():
		return sounds[_tile_id]
	else:
		return null
