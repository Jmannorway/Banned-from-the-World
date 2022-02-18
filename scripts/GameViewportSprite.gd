extends Sprite

var viewport : GameViewport

func update():
	if !Engine.editor_hint:
		var _texture = texture as ViewportTexture
		if _texture:
			yield(get_tree().get_root(), "ready")
			viewport = owner.get_node(_texture.viewport_path) as GameViewport
			if viewport:
				if viewport.mode == viewport.MODE.TWO_DIMENSIONAL:
					scale = Vector2.ONE * 2
				else:
					scale = Vector2.ONE
			else:
				print("GameViewportSprite: No GameViewport assigned")
		else:
			print("GameViewportSprite: No ViewportTexture assigned")

func _ready():
	update()
