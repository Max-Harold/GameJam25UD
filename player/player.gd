extends CharacterBody2D

signal dies

@export var camera_x_minimum: float = 750.0
@export var camera_y_maximum: float = 325.0

var is_dead: bool = false
var is_invincible: bool = false
var accum_time: float = 0
const invincibility_duration: float = .5

@export var healthbar: ProgressBar
const health_max: int = 100
var health: int = 100

@export var SPEED = 350.0
@export var JUMP_VELOCITY = -500.0

const fireball_scale: float = .5
const fireball_pad: float = 50

@onready var _animated_sprite = $AnimatedSprite2D
@onready var hurt=$Hurt
@onready var scream=$Scream
var playedscream=false

var foirball:PackedScene

func _ready()->void:
	foirball=preload('res://foirball/foirball.tscn')

func update_health(delta_health: int):
	if not is_invincible:
		if not is_dead:
			hurt.play()
		health = clamp(health + delta_health, 0, health_max)
		healthbar.change_health(health)
	if health == 0:
		die()
	elif delta_health < 0 and not is_invincible:
		material.set_shader_parameter('alpha', .6)
		is_invincible = true
		accum_time = 0

func die():
	if not is_dead:
		is_dead = true
		_animated_sprite.play("ko")
		dies.emit()

func _process(_delta):
	var camera_pos: Vector2 = $Camera2D.global_position
	$Camera2D.global_position = Vector2(max(global_position.x, camera_x_minimum), min(global_position.y, camera_y_maximum))
	material.set_shader_parameter('lvl',Globals.lvl)
	if is_invincible:
		accum_time += _delta
		if accum_time >= invincibility_duration:
			accum_time = 0
			is_invincible = false
			material.set_shader_parameter('alpha', 1)

	if not is_dead:
		if Input.is_action_pressed("move_right") and is_on_floor():
			#_animated_sprite.flip_h = false
			_animated_sprite.play("walk")
		elif (Input.is_action_pressed("move_left") or  Input.is_action_pressed("move_left")) and is_on_floor():
			#_animated_sprite.flip_h = true
			_animated_sprite.play("walk")
		elif is_on_floor():
			_animated_sprite.play("idle")
		else:
			_animated_sprite.stop()
			
		if Input.is_action_pressed("move_left"):
			_animated_sprite.flip_h = true
		elif Input.is_action_pressed("move_right"):
			_animated_sprite.flip_h = false
	if position.y > 400 and not playedscream:
		print('playing scream')
		scream.play()
		playedscream=true
	if position.y > 1800:
		die()

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
	var direction := Input.get_axis("move_left", "move_right")
	if not is_dead:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("spikes"):
			update_health(Globals.damage_done['spikes'])
		if collision.get_position().y > global_position.y:
			if collider.is_in_group('stompable'):
				collider.queue_free()
		if collider.is_in_group('slimer'):
			update_health(Globals.damage_done['slimer'])
		#else:
			#if not is_invincible:
				#if collider.is_in_group('color_hound'):
					#update_health(Globals.damage_done["color_hound"])
				#elif collider.is_in_group('foirwizard'):
					#update_health(Globals.damage_done["foirwizard"])

func get_center_position():
	return $ChestMarker.global_position

func _input(event)->void:
	if not is_dead:
		if event is InputEventMouseButton:
			if event.pressed and Globals.lvl!=0:
				var inst=foirball.instantiate()
				inst.position = $ChestMarker.position
				inst.scale = Vector2(fireball_scale, fireball_scale)
				inst.set_init_data($Camera2D.get_global_mouse_position() - global_position, true)
				inst.position += inst.direction * fireball_pad * fireball_scale
				add_child(inst)
