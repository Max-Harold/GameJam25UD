extends CharacterBody2D

signal dies

var is_dead: bool = false
var is_invincible: bool = false
var accum_time: float = 0
const invincibility_duration: float = .5

@export var healthbar: ProgressBar
const health_max: int = 100
var health: int = 100

@export var SPEED = 350.0
@export var JUMP_VELOCITY = -500.0

@onready var _animated_sprite = $AnimatedSprite2D

var foirball:PackedScene

func _ready()->void:
	material.set_shader_parameter('lvl',Globals.lvl)
	foirball=preload('res://foirball/foirball.tscn')

func update_health(delta_health: int):
	if not is_invincible:
		health = clamp(health + delta_health, 0, health_max)
		healthbar.change_health(health)
	if health == 0:
		die()
	elif delta_health < 0 and not is_invincible:
		_animated_sprite.modulate = Color(1,1,1,.6)
		is_invincible = true
		accum_time = 0

func die():
	if not is_dead:
		is_dead = true
		_animated_sprite.play("ko")
		dies.emit()

func _process(_delta):
	if is_invincible:
		accum_time += _delta
		if accum_time >= invincibility_duration:
			accum_time = 0
			is_invincible = false
			_animated_sprite.modulate = Color(1,1,1,1)

	if not is_dead:
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
	if not is_dead:
		# Handle jump.
		if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
			velocity.y = JUMP_VELOCITY
			_animated_sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if not is_dead:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		
		var collider = collision.get_collider()
		if collision.get_position().y > global_position.y:
			print(collider.name)
			if collider.name == "ColorHound" or collider.name == "foirwizard":
				collider.queue_free()
		else:
			if collider.name == "ColorHound" and not is_invincible:
				update_health(Globals.damage_done["color_hound"])
			

func _input(event)->void:
	if event is InputEventMouseButton:
		if event.pressed and Globals.lvl!=0:
			var inst=foirball.instantiate()
			inst.set_init_data(event.position-position,true)
			add_child(inst)
