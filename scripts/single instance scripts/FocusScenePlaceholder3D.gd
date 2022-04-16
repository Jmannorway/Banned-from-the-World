tool

extends MeshInstance

func _process(delta):
	rotation_degrees += Vector3.ONE * delta * 100
