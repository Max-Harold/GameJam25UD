extends Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		if Globals.lvl == 0:
			Globals.lvl=3
			visible = false
			await get_tree().create_timer(1.3).timeout
			get_tree().change_scene_to_file("res://scenes/levelTwo.tscn")	
			
		
