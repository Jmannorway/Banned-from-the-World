extends AnimatedSprite

func _on_interactable_2d_interacted():
	get_tree().change_scene("res://scenes/maps/city/city_map.tscn")
