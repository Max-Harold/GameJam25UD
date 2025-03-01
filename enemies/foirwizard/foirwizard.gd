extends CharacterBody2D
var foirball:PackedScene
var sum=0.0
func _ready()->void:
	foirball=preload('res://foirball/foirball.tscn')
func _process(delta:float)->void:
	sum+=delta
	if sum>1:
		sum=0.0
		var inst=foirball.instantiate()
		inst.set_init_data(get_tree().get_first_node_in_group('player').get_position())
		add_child(inst)
