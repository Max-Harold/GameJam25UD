extends CharacterBody2D

@export var healthbar: ProgressBar
const health_max: int = 100
var health: int = 100

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var _animated_sprite = $AnimatedSprite2D

func update_health(delta_health: int):
	health = clamp(health + delta_health, 0, health_max)
	healthbar.change_health(health)
	if health == 0:
		die()

func die():
	print("dead...")

func _process(_delta):
	if Input.is_action_pressed("ui_right") and is_on_floor():
		_animated_sprite.flip_h = false
		_animated_sprite.play("walk")
	elif Input.is_action_pressed("ui_left") and is_on_floor():
		_animated_sprite.flip_h = true
		_animated_sprite.play("walk")
	elif is_on_floor():
		_animated_sprite.play("idle")
	else:
		_animated_sprite.stop()

func _physics_process(delta:  float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		_animated_sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		
		var collider = collision.get_collider()
		if collision.get_position().y > global_position.y:
			if collider.name == "ColorHound":
				collider.queue_free()
		else:
			if collider.name == "ColorHound":
				update_health(Globals.damage_done["color_hound"])
			
