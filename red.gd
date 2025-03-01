extends Sprite2D

func _ready():
	if Globals.lvl != 0:
		visible = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		if Globals.lvl == 0:
			Globals.lvl=3
			visible = false
			get_tree().get_first_node_in_group("handler").win()
			await get_tree().create_timer(3.3).timeout
			get_tree().change_scene_to_file("res://scenes/levelTwo.tscn")	
			
		
