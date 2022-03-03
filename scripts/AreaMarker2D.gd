extends Sprite

class_name AreaMarker2D

export(bool) var hide_on_ready = true

func _ready():
	visible = !hide_on_ready

func get_rect() -> Rect2:
	var _rect = .get_rect()
	_rect.position += position
	_rect.size *= scale
	return _rect

func get_integer_rect() -> Rect2:
	var _rect = get_rect()
	return Rect2(
		Util.floor_v2(_rect.position / Game.SNAP),
		Util.floor_v2(_rect.size / Game.SNAP))
