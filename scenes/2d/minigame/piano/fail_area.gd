extends Area2D

func _on_fail_area_area_entered(area):
	area.queue_free()
