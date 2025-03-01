extends RigidBody2D

@onready var left_raycast=$left_raycast
@onready var right_raycast=$right_raycast
var health = 10

func update_health(change)->void:
	health+=change
	if health<=0:
		queue_free()

func _ready() -> void:
	set_linear_velocity(Vector2(200,200))
func pythag(v:Vector2):
	return sqrt(v.x*v.x+v.y*v.y)

func _physics_process(delta:float)->void:
	if abs(linear_velocity.x)<=500:
		if left_raycast.is_colliding():
			linear_velocity.x+=100
		elif right_raycast.is_colliding():
			linear_velocity.x-=100

func _on_collision(body)->void:
	if left_raycast.is_colliding():
		linear_velocity.x=1000
	elif right_raycast.is_colliding():
		linear_velocity.x=-1000
