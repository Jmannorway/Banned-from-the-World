extends Node

onready var navigationTileMap: TileMap = $Navigation2D/navigation_mesh
onready var solidGrid: TileMap = $solid_grid

onready var sound_grid := $sound_grid_2d
# onready var solid_grid := $solid_grid_2d
# onready var navigation_grid := $navigation_grid_2d

func update_snap() -> void:
	solidGrid.cell_size = Vector2(Game.SNAP, Game.SNAP)

func _on_MapManager_MapChanged() -> void:
	solidGrid.clear()

func _ready():
	update_snap()
	MapManager.connect("changing_map", self, "_on_MapManager_MapChanged")

func set_solid_cell(var x: int, var y: int, var tileID: int) -> void:
	solidGrid.set_cell(x, y, tileID)

func get_solid_cell(var position: Vector2) -> int:
	return solidGrid.get_cellv(solidGrid.world_to_map(position))

func move_solid(var fromPosition: Vector2, var moveDirection: Vector2) -> void:
	var _gridFromPos: Vector2 = solidGrid.world_to_map(fromPosition)
	var _gridMovePos: Vector2 = solidGrid.world_to_map(fromPosition + moveDirection)
	
	solidGrid.set_cellv(_gridFromPos, TileMap.INVALID_CELL)
	solidGrid.set_cellv(_gridMovePos, 0)

func set_navigation_cell(var x: int, var y: int, var tileID: int) -> void:
	navigationTileMap.set_cell(x, y, tileID)

func get_navigation_path(var from: Vector2, var to: Vector2) -> PoolVector2Array:
	return $Navigation2D.get_simple_path(from, to, true) as PoolVector2Array

func snap_point(var point: Vector2) -> Vector2:
	point.x /= navigationTileMap.cell_size.x
	point.y /= navigationTileMap.cell_size.y
	
	point.x = floor(point.x)
	point.y = floor(point.y)
	
	point.x *= navigationTileMap.cell_size.x
	point.y *= navigationTileMap.cell_size.y
	
	return point
