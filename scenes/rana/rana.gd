extends CharacterBody2D



@export var speed : float = 900.0
@export var pushback : float = 900.0
@export var jump_velocity : float = -1700.0
@export var gravity : float = 3234.0
@export var friction : float = 115
@export var acc : float = 90

#var canmove = true
var state = 5
var on_wall = false
var cooldown = false
var current_direction = 0

#MODIFICADO
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
func fireball():
	$AnimationTree["parameters/conditions/is_burning"] = true
	$Fireball.burn()

func squashed():
	$CollisionNormal.set_disabled(true)
	$CollisionSquashed.set_disabled(false)

func is_direction_flipped(new_direction):
	return current_direction * new_direction < 0
	
func is_wall_sliding():
	return state >= 2 and (on_wall or is_on_wall()) and Input.is_key_pressed(KEY_C)

func _ready():
	$CollisionSquashed.set_disabled(true)

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept"):
		
		$AnimationTree["parameters/conditions/is_jumping"] = true
		$AnimationTree["parameters/conditions/is_landing"] = false
		if is_on_floor():
			velocity.y = jump_velocity
		if is_wall_sliding() and Input.is_action_pressed("ui_left"):
			velocity.y = jump_velocity
			velocity.x = -pushback
			on_wall = false
		if is_wall_sliding() and Input.is_action_pressed("ui_right"):
			velocity.y = jump_velocity
			velocity.x = pushback
			on_wall = false
			
	# state 1
	if state >= 1 and Input.is_key_pressed(KEY_X) and not cooldown:
		cooldown = true
		fireball()
	else:
		$AnimationTree["parameters/conditions/is_burning"] = false
	
	# state 2
	if state >= 2 and is_wall_sliding():
		on_wall = true
		velocity.y += 0.0005 * gravity * delta
		velocity.y = max(0, velocity.y)
	
	#state 3
	if state >= 3 and Input.is_key_pressed(KEY_Z):
		squashed()
	if not is_wall_sliding():
		if direction:
			velocity.x = direction * speed
			if is_direction_flipped(velocity.x) or (current_direction == 0 and velocity.x < 0):
				self.scale.x = -self.scale.x
			current_direction = velocity.x
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	update_animation()
	move_and_slide()

func _on_walljump_timer_timeout():
	velocity.x = 0
	#canmove = true
