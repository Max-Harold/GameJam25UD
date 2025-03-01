extends Sprite2D


var direction:Vector2
const fireball_speed: float = 1000.0
var dest_vector: Vector2
var plyrspwnd:bool
var left_source: bool = false
@onready var player=$AudioStreamPlayer
var lifetime: float = 3.0
var accum: float = 0.0

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
	player.play()
	#look_at(dest_vector)
func _process(delta: float)->void:
	accum += delta
	if accum >= lifetime:
		queue_free()
	var pos=get_global_position()
	pos += fireball_speed * delta * direction
	set_global_position(pos)
func _on_area_2d_body_entered(body: Node2D) -> void:
	var to_collider: Vector2 = body.global_position - global_position
	var is_pointing_at_collider: bool = to_collider.dot(direction) > 0
	#print(body.name)
	if plyrspwnd:
		if body.is_in_group('enemy'):
			print(body.name)
			body.update_health(Globals.damage_done['foirball'])
		if not body.is_in_group('player'):
			#print("removing after "+body.name)
			queue_free()
	else:
		if body.is_in_group('player'):
			body.update_health(Globals.damage_done['foirball'])
		if not body.is_in_group('foirwizard'):
			queue_free()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if plyrspwnd and body.is_in_group('player'):
		left_source = true
	elif not plyrspwnd and body.is_in_group('foirwizard'):
		left_source = true
