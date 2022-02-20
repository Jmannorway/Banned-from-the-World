extends ResourceGrid2D

class_name SoundGrid2D

export(Array) var sounds
export(Resource) var default_sound

func set_sounds(new_sounds : Array):
	sounds = new_sounds.duplicate()

func paint_to_world_grid():
	.paint_to_world_grid()
	WorldGrid.sound_grid.set_sounds(sounds)

func get_cell_sound(x : int, y : int) -> AudioStreamSample:
	var _tile_id = get_cell(x, y)
	if _tile_id >= 0 && _tile_id < sounds.size():
		return sounds[_tile_id]
	else:
		return default_sound

func play_cell_sound(x : int, y : int) -> void:
	$AudioStreamPlayer.stream = get_cell_sound(x, y)
	if $AudioStreamPlayer.stream != null:
		$AudioStreamPlayer.play()

func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.sound_grid.set_cell(world_x, world_y, get_cell(x, y))

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	WorldGrid.sound_grid.set_cell(world_x, world_y, INVALID_CELL)
