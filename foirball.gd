extends Sprite2D
var dest:Vector2#the point we're moving towards
func set_init_data(data):
	var scale=1000000
	dest=Vector2(data.x*scale,data.y*scale)
func _ready()->void:
	look_at(Vector2(-dest.x,-dest.y))
func _process(delta: float)->void:
	var pos=get_position()
	var xd=dest.x-pos.x
	var yd=dest.y-pos.y
	var t=sqrt(xd*xd+yd*yd)/10
	set_position(Vector2(pos.x+xd/t,pos.y+yd/t))
