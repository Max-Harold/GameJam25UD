extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED: float = 300.0
const JUMP_VELOCITY = -400.0

# positive - right
var x_velocity: float = -SPEED

@onready var left_down_raycast: RayCast2D = $LeftDownRaycast
@onready var right_down_raycast: RayCast2D = $RightDownRaycast
@onready var right_raycast: RayCast2D = $RightRaycast
@onready var left_raycast: RayCast2D = $LeftRaycast

func _ready() -> void:
	x_velocity = -SPEED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	velocity.x = x_velocity
	var movingRight: bool = x_velocity > 0
	if movingRight and ((not right_down_raycast.is_colliding() and is_on_floor()) or right_raycast.is_colliding()) :
		x_velocity = -x_velocity
		animated_sprite.flip_h = false
	elif not movingRight and ((not left_down_raycast.is_colliding() and is_on_floor()) or left_raycast.is_colliding()):
		x_velocity = -x_velocity
		animated_sprite.flip_h = true

	move_and_slide()
