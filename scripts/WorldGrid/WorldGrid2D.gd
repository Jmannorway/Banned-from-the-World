extends Node

export(PackedScene) var solid_grid_scene
export(PackedScene) var navigation_grid_scene
export(PackedScene) var sound_grid_scene
export(PackedScene) var interactable_grid_scene
const LAYER_COUNT := 8

func _enter_tree() -> void:
	_create_grids()

func _ready():
# warning-ignore:return_value_discarded
	MapManager.connect("changing_map", self, "_clear_grids")
	
# VARIOUS UTILITY
func _create_grids() -> void:
	var _inst
	for i in LAYER_COUNT:
		_inst = solid_grid_scene.instance() as SolidGrid2D
		_inst.add_on_ready = false
		$solid_grids.add_child(_inst)
		
		_inst = Navigation2D.new()
		$navigation_grids.add_child(_inst)
		_inst = navigation_grid_scene.instance() as NavigationGrid2D
		_inst.add_on_ready = false
		$navigation_grids.get_child(i).add_child(_inst)
		
		_inst = sound_grid_scene.instance() as SoundGrid2D
		_inst.add_on_ready = false
		$sound_grids.add_child(_inst)
		
		_inst = interactable_grid_scene.instance() as InteractableGrid2D
		_inst.add_on_ready = false
		$interactable_grids.add_child(_inst)

func _clear_grids() -> void:
	for i in LAYER_COUNT:
		get_solid_grid(i).clear()
		get_navigation_grid(i).clear()
		get_sound_grid(i).clear()

func get_solid_grid(layer : int) -> SolidGrid2D:
	return $solid_grids.get_child(layer) as SolidGrid2D

func get_navigation(layer : int) -> Navigation2D:
	return $navigation_grids.get_child(layer) as Navigation2D

func get_navigation_grid(layer : int) -> NavigationGrid2D:
	return $navigation_grids.get_child(layer).get_child(0) as NavigationGrid2D

func get_sound_grid(layer : int) -> SoundGrid2D:
	return $sound_grids.get_child(layer) as SoundGrid2D

func get_interactable_grid(layer : int) -> InteractableGrid2D:
	return $interactable_grids.get_child(layer) as InteractableGrid2D
