extends Spatial
tool

export(int) var big_amount : int setget set_big_amount
func set_big_amount(val : int) -> void:
	var big_part = get_node_or_null("Big")
	if big_part:
		big_part.amount = val
	big_amount = val

export(int) var medium_amount : int setget set_medium_amount
func set_medium_amount(val : int) -> void:
	var medium_part = get_node_or_null("Medium")
	if medium_part:
		medium_part.amount = val
	medium_amount = val

export(Texture) var point_texture : Texture setget set_point_texture
func set_point_texture(val : Texture) -> void:
	var big_part = get_node_or_null("Big")
	var medium_part = get_node_or_null("Medium")
	if big_part:
		$Big.process_material .emission_point_texture = val
	if medium_part:
		$Medium.process_material.emission_point_texture = val
	point_texture = val
