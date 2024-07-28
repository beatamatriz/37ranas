extends CharacterBody2D

@export var speed : float = 900.0
@export var pushback : float = 900.0
@export var jump_velocity : float = -1700.0
@export var gravity : float = 3234.0
@export var friction : float = 115
@export var acc : float = 90

const god = true

var state = 0
var on_wall = false
var cooldown = false
var current_direction = 0

# AUX

func is_direction_flipped(new_direction):
	return current_direction * new_direction < 0

func update_animation():
	if is_on_floor():
		if velocity == Vector2.ZERO:
			$AnimationTree["parameters/conditions/is_running"] = false
			$AnimationTree["parameters/conditions/is_idle"] = true
		else:
			$AnimationTree["parameters/conditions/is_running"] = true
			$AnimationTree["parameters/conditions/is_idle"] = false
	if velocity.y == 0 and is_on_floor():
		$AnimationTree["parameters/conditions/is_jumping"] = false
		$AnimationTree["parameters/conditions/is_landing"] = true 

# STATE 1

func burn():
	state = 1
	$Fire_Sprite.visible = true
	$FireAnimationTree["parameters/conditions/is_burning"] = true
	$AnimationTree["parameters/conditions/is_burned"] = true

func fireball():
	$AnimationTree["parameters/conditions/is_burning"] = true
	$Fireball.burn()

# STATE 2

func break_leg():
	state = 2
	$AnimationTree["parameters/conditions/is_leg_broken"] = true

# STATE 3

func handle_anvil():
	pass

func squash():
	state = 4
	$Fire_Sprite.visible = false
	$AnimationTree["parameters/conditions/is_squashed"] = true
	$CollisionNormal.set_disabled(true)
	$CollisionSquashed.set_disabled(false)

# EVENTS

func _ready():
	$Fire_Sprite.visible = false
	$CollisionSquashed.set_disabled(true)

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept"):
		
		$AnimationTree["parameters/conditions/is_jumping"] = true
		$AnimationTree["parameters/conditions/is_landing"] = false
		if is_on_floor() or not $AnimationTree["parameters/conditions/is_jumping"]:
			velocity.y = jump_velocity
		if state >= 2 and is_on_wall() and Input.is_action_pressed("ui_left"):
			velocity.y = jump_velocity
			velocity.x = pushback
			on_wall = false
		if state >= 2 and is_on_wall() and Input.is_action_pressed("ui_right"):
			velocity.y = jump_velocity
			velocity.x = -pushback
			on_wall = false
			
	# state 1
	if god and Input.is_key_pressed(KEY_7):
		self.burn()
	if (state >= 1 or god) and Input.is_key_pressed(KEY_X) and not cooldown:
		cooldown = true
		fireball()
	else:
		$AnimationTree["parameters/conditions/is_burning"] = false
	
	# state 2

	
	#state 3
	if state == 3 or (god and Input.is_key_pressed(KEY_0)):
		squash()
		
	if direction:
		velocity.x = direction * speed
		if is_direction_flipped(velocity.x) or (current_direction == 0 and velocity.x < 0):
			self.scale.x = -self.scale.x
		current_direction = velocity.x
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if god and Input.is_key_pressed(KEY_1):
		break_leg()
	update_animation()
	move_and_slide()

func _on_walljump_timer_timeout():
	velocity.x = 0
	#canmove = true
