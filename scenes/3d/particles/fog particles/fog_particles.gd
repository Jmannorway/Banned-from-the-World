extends Spatial
tool

export(float) var emission_ring_radius : float setget set_emission_ring_radius
func set_emission_ring_radius(val : float) -> void:
	emission_ring_radius = val
	update_process_material_property_in_children("emission_ring_radius")

export(float) var emission_ring_inner_radius : float setget set_emission_ring_inner_radius
func set_emission_ring_inner_radius(val : float) -> void:
	emission_ring_inner_radius = val
	update_process_material_property_in_children("emission_ring_inner_radius")

export(float) var emission_ring_height : float setget set_emission_ring_height
func set_emission_ring_height(val : float) -> void:
	emission_ring_height = val
	update_process_material_property_in_children("emission_ring_height")

export(Vector3) var emission_ring_axis : Vector3 setget set_emission_ring_axis
func set_emission_ring_axis(val : Vector3) -> void:
	emission_ring_axis = val
	update_process_material_property_in_children("emission_ring_axis")

func update_process_material_property_in_children(property : String) -> void:
	Util.set_in_children_ext(self, ["process_material"], property, get(property))
