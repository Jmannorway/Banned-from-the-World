extends Sprite

class_name GameViewportSprite

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
					region_rect = Rect2(Vector2.ZERO, Vector2(480, 360))
				else:
					scale = Vector2.ONE
					region_rect = Rect2(Vector2.ZERO, Vector2(960, 720))
			else:
				print("GameViewportSprite: No GameViewport assigned")
		else:
			print("GameViewportSprite: No ViewportTexture assigned")

func _ready():
	update()
	region_enabled = true

func set_mode(two_dimensional : bool) -> void:
	if two_dimensional:
		scale = Vector2.ONE * 2
		region_rect = Rect2(Vector2.ZERO, Vector2(480, 360))
	else:
		scale = Vector2.ONE
		region_rect = Rect2(Vector2.ZERO, Vector2(960, 720))
