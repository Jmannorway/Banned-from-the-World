extends Node2D

func _process(delta):
	WorldGrid.get_solid_grid(0).set_solid_at_pixel(global_position, true)

func _on_spin_timer_timeout():
	var _sprite = $animated_character_sprite_2d as AnimatedCharacterSprite2D
	match _sprite.animation:
		"up":
			_sprite.set_sprite_direction(Vector2.LEFT)
		"right":
			_sprite.set_sprite_direction(Vector2.UP)
		"left":
			_sprite.set_sprite_direction(Vector2.DOWN)
		"down":
			_sprite.set_sprite_direction(Vector2.RIGHT)
