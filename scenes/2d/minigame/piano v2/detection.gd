tool

extends Area2D

export(float, 32.0, 128.0) var key_distance = 64.0 setget set_key_distance
func set_key_distance(new_key_distance : float):
	key_distance = new_key_distance
	
	for i in Game.DIR4.MAX:
		get_child(i).position = Game.VDIR4[i] * key_distance

var overlaps : Array

# Rhythm controller functions

func is_overlapping(dir : int) -> bool:
	return overlaps[dir].size() > 0

func remove_first(dir : int):
	overlaps[dir][0].queue_free()
	overlaps[dir].remove(0)

func arrow_feedback(dir : int):
	var _animation_player = get_child(dir).get_child(0).get_node("glow")
	if _animation_player.is_playing():
		_animation_player.stop()
	_animation_player.play("glow")

# Behavior

func _ready():
	overlaps.resize(Game.DIR4.MAX)
	for i in Game.DIR4.MAX:
		overlaps[i] = Array()

# Callbacks

func _on_detection_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	overlaps[local_shape_index].push_back(area)

func _on_detection_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var i = overlaps[local_shape_index].find(area)
	if i != -1:
		overlaps[local_shape_index].remove(i)
