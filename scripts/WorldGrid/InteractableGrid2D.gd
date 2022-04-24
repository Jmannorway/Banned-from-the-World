extends ResourceGrid2D

class_name InteractableGrid2D

"""
This grid exists to contain information about what tiles interactables stand on
not to be confused with solid grid tiles for characters since some characters
aren't solid. Use like you would a tilemap when adding and removing tiles.

In other words; this tilemap is used to separate interactable collisions on
different layers.
"""

var world_interactable_grid

func _ready() -> void:
	world_interactable_grid = WorldGrid.get_interactable_grid(layer)

func _add_cell_to_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_interactable_grid.set_cell(world_x, world_y, get_cell(x, y))

func _clear_cell_in_world_grid(x : int, y : int, world_x : int, world_y : int):
	world_interactable_grid.set_cell(world_x, world_y, 0)
