extends Spatial

class OffsetTarget:
	var target : Spatial
	var previous_translation : Vector3
	var previous_rotation : Vector3
	var offset_translation : bool
	var offset_rotation : bool
	func get_rotation_offset() -> Vector3:
		return (target.rotation - previous_rotation) * int(offset_rotation)
	func get_translation_offset() -> Vector3:
		return (target.translation - previous_translation) * int(offset_translation)
	func offset_handled() -> void:
		previous_rotation = target.rotation
		previous_translation = target.translation
	func _init(_target : Spatial, _offset_translation : bool, _offset_rotation : bool):
		target = _target
		previous_translation = target.translation
		previous_rotation = target.rotation
		offset_translation = _offset_translation
		offset_rotation = _offset_rotation

var offset_targets : Dictionary

func add_offset_target(node : Spatial, offset_translation : bool, offset_rotation : bool) -> void:
	if !offset_targets.has(node.name):
		offset_targets[node.name] = OffsetTarget.new(node, offset_translation, offset_rotation)

func remove_offset_target(node : Spatial):
	if offset_targets.has(node.name):
		offset_targets.erase(node.name)

func apply_offsets():
	for target in offset_targets:
		$camera.translation += translation
		$camera.rotation += rotation
		translation = Vector3.ZERO
		rotation = Vector3.ZERO
		offset_targets.clear()

func reset():
	offset_targets.clear()
	translation = Vector3.ZERO
	rotation = Vector3.ZERO

func _process(delta: float) -> void:
	for target in offset_targets:
		translation += offset_targets[target].get_translation_offset()
		rotation += offset_targets[target].get_rotation_offset()
		offset_targets[target].offset_handled()
