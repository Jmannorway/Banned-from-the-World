tool

extends Sprite

class_name PlayerStart2D

##@desc: Name of the room loader that has the room corresponding to the spawn location
export(String) var room_name

##@desc: Room layer to start on
export(int) var room_layer setget set_room_layer
func set_room_layer(val : int) -> void:
	if val >= 0 && val < WorldGrid.LAYER_COUNT:
		room_layer = val
	else:
		print("PlayerStart2D: Invalid room_layer index")

##@desc: Index to start at
export(int) var index : int = 0
const CHECKPOINT_INDEX : int = 9999

# Makes this instance's index unique by setting the other indices
export(bool) var make_unique setget set_make_unique
func set_make_unique(val):
	make_index_unique()

func _ready():
	visible = Engine.editor_hint
	
	if MapManager.player_start_index == index:
		if !room_name.empty():
			var _room_manager = MapManager.get_room_manager()
			_room_manager.focus_room(room_name)
			_room_manager.get_room_loader_by_name(room_name).connect("loaded", self, "create_or_place_player")
		MapManager.reset_player_start_index()

func create_or_place_player(_room_loader) -> void:
	var _player = PlayerAccess.get_player_2d(get_tree())
	if !_player:
		_player = PlayerAccess.spawn_player_in_room_2d(room_name, room_layer)
	if _player:
		_player.position = Util.snap_v2(position, Game.SNAP) + Vector2.ONE * Game.SNAP / 2

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
