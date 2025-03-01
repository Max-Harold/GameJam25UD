extends Sprite2D
var dest:Vector2
func set_init_data(data):
	var pos=get_global_position()
	var xd=data.x-pos.x
	var yd=data.y-pos.y
	var scale=1000000
	dest=Vector2(pos.x+xd*scale,pos.y+yd*scale)
func _ready()->void:
	look_at(Vector2(-dest.x,-dest.y))
func _process(delta: float)->void:
	var pos=get_global_position()
	var xd=dest.x-pos.x
	var yd=dest.y-pos.y
	var t=sqrt(xd*xd+yd*yd)/10
	set_global_position(Vector2(pos.x+xd/t,pos.y+yd/t))
func _on_area_2d_body_entered(body: Node2D) -> void:
	pass
	#queue_free()
