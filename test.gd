extends Node2D
func _ready() -> void:
	var foirball=preload("res://foirball.tscn").instantiate()
	foirball.set_init_data(Vector2(100,100))
	add_child(foirball)
func _process(delta: float) -> void:
	pass
