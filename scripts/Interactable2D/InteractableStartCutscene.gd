extends Interactable2D

export var animPath: NodePath
export var animName: String

onready var anim: AnimationPlayer = get_node(animPath)

func step():
	anim.play(animName)
