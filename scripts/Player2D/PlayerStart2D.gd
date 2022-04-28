tool

extends Sprite

class_name PlayerStart2D

export(String) var room_name
const CHECKPOINT_INDEX := 9999
export var index := 0

# Makes this instance's index unique by setting the other indices
export(bool) var make_unique setget set_make_unique
func set_make_unique(val):
	make_index_unique()

func _ready():
	visible = Engine.editor_hint
	
	if MapManager.player_start_index == index:
		var _player = PlayerAccess.get_player_2d(get_tree())
		if !_player:
			_player = PlayerAccess.spawn_player_2d()
		
		_player.position = Util.snap_v2(position, Game.SNAP) + Vector2.ONE * Game.SNAP / 2
		MapManager.reset_player_start_index()
		
		if !room_name.empty():
			MapManager.get_room_manager().focus_room(room_name)

func make_index_unique():
	var _counters = get_tree().get_nodes_in_group(get_groups()[0])
	for i in _counters:
		if i != self && i.index == index:
			i.index = find_first_unique(i.index)
			prints("PlayerStart2D: ", i.name, "'s index was set to", i.index)

func find_first_unique(ind : int) -> int:
	var _indices : Array
	var _counters = get_tree().get_nodes_in_group(get_groups()[0])
	_indices.resize(_counters.size())
	for i in _counters.size():
		_indices[i] = _counters[i].index
	_indices.sort()
	
	var _lowest := -1
	for i in _indices:
		if i - 1 > _lowest:
			return _lowest + 1
		_lowest = max(_lowest, i)
	return _indices[-1] + 1
