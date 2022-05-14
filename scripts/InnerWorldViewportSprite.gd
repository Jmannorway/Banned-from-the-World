extends GameViewportSprite

export(Array, ShaderMaterial) var effects
export(int) var effect = 0 setget set_effect
func set_effect(index : int) -> void:
	material = effects[index]
	effect = index
func set_next_effect() -> void:
	set_effect((effect + 1) % effects.size())

func _ready():
	set_effect(effect)
