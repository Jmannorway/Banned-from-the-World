tool

extends Spatial

export(Color) var albedo_near setget set_albedo_near
func set_albedo_near(val):
	albedo_near = val
	update_colors()

export(Color) var albedo_far setget set_albedo_far
func set_albedo_far(val):
	albedo_far = val
	update_colors()

func update_colors():
	var _child_count = get_child_count()
	for i in _child_count:
		get_child(i).get_surface_material(0).set_shader_param("albedo", albedo_near.linear_interpolate(albedo_far, i / (_child_count-1)))
