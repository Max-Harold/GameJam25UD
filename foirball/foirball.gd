extends Sprite2D


var direction:Vector2
const fireball_speed: float = 1000.0
var dest_vector: Vector2
func set_init_data(data):
	dest_vector = data
	var pos=get_global_position()
	var dx=data.x-pos.x
	var dy=data.y-pos.y
	#var scale=1000000
	direction = Vector2(dx, dy).normalized()
func _ready()->void:
	rotate(direction.angle())
	#look_at(dest_vector)
func _process(delta: float)->void:
	var pos=get_global_position()
	pos += fireball_speed * delta * direction
	set_global_position(pos)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.update_health(Globals.damage_done['foirball'])
	print("colliede with "+body.name)
	if body.name != "foirwizard":
		queue_free()
