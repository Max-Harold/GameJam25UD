extends Sprite2D
@onready var player=$AudioStreamPlayer
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		if Globals.lvl == 0:
			player.play()
			Globals.lvl=3
			visible = false
			get_tree().get_first_node_in_group("root").win()
			await get_tree().create_timer(3.3).timeout
			get_tree().change_scene_to_file("res://scenes/levelTwo.tscn")	
			
		
