extends GridMap

export(NodePath) var room_path
export(bool) var add_on_ready

func _ready():
	if add_on_ready:
		add_to_room_grid()

func add_to_room_grid():
	if !room_path.is_empty():
		add(get_node(room_path).gridMap)
	else:
		add(Util.get_first_node_in_group(get_tree(), "room_grid"))

func add(room_grid : GridMap):
	for v in room_grid.get_used_cells():
		room_grid.set_cell_item(v.x, v.y, v.z, GridMap.INVALID_CELL_ITEM, 0)
	for v in get_used_cells():
		room_grid.set_cell_item(v.x, v.y, v.z, get_cell_item(v.x, v.y, v.z))
