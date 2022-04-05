extends MeshInstance

func _process(delta):
	var shader_material = get_surface_material(0) as ShaderMaterial;
	shader_material.set_shader_param("alpha", XToFocus.alpha)
