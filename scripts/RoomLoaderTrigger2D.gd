extends Area2D

enum ROOM_LOADER_ACTION {LOAD, UNLOAD}

export var room_loader_name := ""
export(ROOM_LOADER_ACTION) var action

func _on_Area2D_body_entered(body):
	if action == ROOM_LOADER_ACTION.LOAD:
		MapManager.load_room(room_loader_name)
	else:
		MapManager.unload_room(room_loader_name)

# dictionary + room name based approach
# pros: ????
# cons: ????

#export var room_loader_name : String # Name of the room loader that you want to use to load a room
#
#func _on_Area2D_body_entered(body):
#	var map_manager : MapManager2D = Util.get_first_node_in_group(get_tree(), "map_manager")
#	var room_loader : RoomLoader2D = map_manager.get_room_loader_by_name(room_loader_name)
#	if room_loader:
#		room_loader.set_loaded(true)
#
#func _on_Area2D_body_exited(body):
#	var map_manager : MapManager2D = Util.get_first_node_in_group(get_tree(), "map_manager")
#	var room_loader : RoomLoader2D = map_manager.get_room_loader_by_name(room_loader_name)
#	if room_loader:
#		room_loader.set_loaded(false)

