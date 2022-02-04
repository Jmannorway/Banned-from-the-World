extends TileMap

onready var navigationTileMap: TileMap = $Navigation2D/navigation_mesh

func update_snap() -> void:
	cell_size = Vector2(Game.SNAP, Game.SNAP)

func _on_MapManager_MapChanged() -> void:
	clear()

func _ready():
	update_snap()
	MapManager.connect("changing_map", self, "_on_MapManager_MapChanged")

func set_navigation_cell(var x: int, var y: int, var tileID: int) -> void:
	navigationTileMap.set_cell(x, y, tileID)

func get_navigation_path(var from: Vector2, var to: Vector2) -> PoolVector2Array:
	var _path: PoolVector2Array = $Navigation2D.get_simple_path(from, to, true) as PoolVector2Array
	
#	for i in _path.size():
#		_path[i] = snap_point(_path[i])# + Vector2.ONE * Game.SNAP * 0.5
	
	_path.remove(0)
	
	return _path

func snap_point(var point: Vector2) -> Vector2:
	point.x /= navigationTileMap.cell_size.x
	point.y /= navigationTileMap.cell_size.y
	
	point.x = floor(point.x)
	point.y = floor(point.y)
	
	point.x *= navigationTileMap.cell_size.x
	point.y *= navigationTileMap.cell_size.y
	
	return point
