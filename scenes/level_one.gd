extends Node2D
func _ready() -> void:
	Globals.lvl=0
	material.set_shader_parameter('lvl',0)
