tool

extends Sprite

func _process(delta):
	material.set_shader_param("position", $Position2D.position)
	material.set_shader_param("size", texture.get_size())
