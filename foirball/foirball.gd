extends Sprite2D


var direction:Vector2
const fireball_speed: float = 1000.0
var dest_vector: Vector2
var plyrspwnd:bool
var left_source: bool = false

func set_init_data(data,playrspwnd):
	dest_vector = data
	var pos=get_global_position()
	var dx=data.x-pos.x
	var dy=data.y-pos.y
	#var scale=1000000
	direction = Vector2(dx, dy).normalized()
	plyrspwnd=playrspwnd
func _ready()->void:
	rotate(direction.angle())
	material.set_shader_parameter('lvl',Globals.lvl)
	#look_at(dest_vector)
func _process(delta: float)->void:
	var pos=get_global_position()
	pos += fireball_speed * delta * direction
	set_global_position(pos)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if plyrspwnd:
		if body.is_in_group('enemy'):
			body.update_health(Globals.damage_done['foirball'])
		if not body.is_in_group('player') and left_source:
			queue_free()
	else:
		if body.is_in_group('player'):
			body.update_health(Globals.damage_done['foirball'])
		if not body.is_in_group('foirwizard') and left_source:
			queue_free()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if plyrspwnd and body.is_in_group('player'):
		left_source = true
	elif not plyrspwnd and body.is_in_group('foirwizard'):
		left_source = true
