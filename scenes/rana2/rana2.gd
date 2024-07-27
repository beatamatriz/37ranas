extends CharacterBody2D


@export var speed : float = 900.0
@export var jump_velocity : float = -1700.0
var cooldown = 0
var state = 0
var current_direction = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3.3

func _ready():
	$CollisionSquashed.set_disabled(true)

#MODIFICADO
func fireball():
	$AnimationTree["parameters/conditions/is_burning"] = true
	$Fireball.burn()
	pass

func squashed():
	$CollisionNormal.set_disabled(true)
	$CollisionSquashed.set_disabled(false)

func is_direction_flipped(new_direction):
	return current_direction * new_direction < 0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = jump_velocity
	# State 1
	if Input.is_key_pressed(KEY_X) and not cooldown:
		cooldown = true
		fireball()
	else:
		$AnimationTree["parameters/conditions/is_burning"] = false
	if Input.is_key_pressed(KEY_Z):
		squashed()
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		if is_direction_flipped(velocity.x) or (current_direction == 0 and velocity.x < 0):
			self.scale.x = -self.scale.x
		current_direction = velocity.x
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	update_animation()
	move_and_slide()

#MODIFICADO
func update_animation():
	if velocity == Vector2.ZERO:
		$AnimationTree["parameters/conditions/is_running"] = false
		$AnimationTree["parameters/conditions/is_idle"] = true
	else:
		$AnimationTree["parameters/conditions/is_running"] = true
		$AnimationTree["parameters/conditions/is_idle"] = false
	


func _on_walljump_cooldown_timeout():
	pass # Replace with function body.
