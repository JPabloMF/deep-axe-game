extends Node2D

func _on_Area2D_area_entered(area):
	if 'Player' == area.get_name():
		queue_free()
