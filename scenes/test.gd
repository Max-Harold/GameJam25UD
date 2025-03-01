extends Node2D
func _ready() -> void:
	var foirball=preload('res://foirball/foirball.tscn').instantiate()
	foirball.set_init_data(Vector2(1,1))
	add_child(foirball)
func _process(delta: float) -> void:
	pass
