extends Node

onready var navigation_grid : NavigationGrid2D = $navigation_2d/navigation_grid_2d
onready var solid_grid = $solid_grid_2d
onready var sound_grid : SoundGrid2D = $sound_grid_2d

func _on_MapManager_MapChanged() -> void:
	solid_grid.clear()
	navigation_grid.clear()
	sound_grid.clear()

func _ready():
# warning-ignore:return_value_discarded
	MapManager.connect("changing_map", self, "_on_MapManager_MapChanged")

# VARIOUS UTILITY
func snap_point(var point: Vector2) -> Vector2:
	point.x /= navigation_grid.cell_size.x
	point.y /= navigation_grid.cell_size.y
	
	point.x = floor(point.x)
	point.y = floor(point.y)
	
	point.x *= navigation_grid.cell_size.x
	point.y *= navigation_grid.cell_size.y
	
	return point
