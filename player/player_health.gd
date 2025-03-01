extends ProgressBar

@onready var health_label: Label = $HealthLabel

func change_health(new_health: int):
	health_label.text = "HP: "+str(new_health)
	value = new_health
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
