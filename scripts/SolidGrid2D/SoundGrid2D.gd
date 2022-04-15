extends ResourceGrid2D

class_name SoundGrid2D

export(Array) var sounds
export(Resource) var default_sound
var world_sound_grid

func _enter_tree() -> void:
	world_sound_grid = WorldGrid.get_sound_grid(layer)

func set_sounds(new_sounds : Array):
	sounds = new_sounds.duplicate()

func paint_to_world_grid():
	.paint_to_world_grid()
	WorldGrid.get_sound_grid(layer).set_sounds(sounds)

func get_cell_sound(x : int, y : int) -> AudioStreamSample:
	var _tile_id = get_cell(x, y)
	if _tile_id >= 0 && _tile_id < sounds.size():
		return sounds[_tile_id]
	else:
		return default_sound

func play_cell_sound(x : int, y : int) -> void:
	MusicManager.play_sound(get_cell_sound(x, y))

func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_sound_grid.set_cell(world_x, world_y, get_cell(x, y))

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_sound_grid.set_cell(world_x, world_y, INVALID_CELL)
