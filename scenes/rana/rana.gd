extends CharacterBody2D


var state = 5
@export var speed : float = 900.0
@export var jump_velocity : float = -1700.0
var canmove = true
var cooldown = false
var current_direction = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3.3

#MODIFICADO
func update_animation():
	if velocity == Vector2.ZERO:
		$AnimationTree["parameters/conditions/is_running"] = false
		$AnimationTree["parameters/conditions/is_idle"] = true
	else:
		$AnimationTree["parameters/conditions/is_running"] = true
		$AnimationTree["parameters/conditions/is_idle"] = false

func fireball():
	$AnimationTree["parameters/conditions/is_burning"] = true
	$Fireball.burn()

func squashed():
	$CollisionNormal.set_disabled(true)
	$CollisionSquashed.set_disabled(false)

func is_direction_flipped(new_direction):
	return current_direction * new_direction < 0
	
func is_wall_sliding():
	if !is_on_wall_only():
		return false
	return Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")

func _ready():
	$CollisionSquashed.set_disabled(true)

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if is_wall_sliding():
		velocity.y += 0.0005 * gravity * delta
		velocity.y = max(0, velocity.y)
	elif not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif is_wall_sliding():
			canmove = false
			$WalljumpTimer.start()
			velocity.y = jump_velocity
			velocity.x = -0.5 * speed * current_direction
	# State 1
	if state >= 1 and Input.is_key_pressed(KEY_X) and not cooldown:
		cooldown = true
		fireball()
	else:
		$AnimationTree["parameters/conditions/is_burning"] = false
	
	if state >= 3 and Input.is_key_pressed(KEY_Z):
		squashed()
	
	if direction and canmove:
		velocity.x = direction * speed
		if is_direction_flipped(velocity.x) or (current_direction == 0 and velocity.x < 0):
			self.scale.x = -self.scale.x
		current_direction = velocity.x
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	update_animation()
	move_and_slide()


func _on_walljump_timer_timeout():
	canmove = true
