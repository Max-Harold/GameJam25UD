extends Node2D

@onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("handler")

	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over():
	$CanvasLayer/GameOver.visible = true

func _on_player_dies() -> void:
	game_over()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
