extends CharacterBody2D


const SPEED = 900.0
const JUMP_VELOCITY = -1700.0
var state = 0
var current_direction = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3.3

func _ready():
	$CollisionSquashed.set_disabled(true)

#función quemar cosas
func fireball():
	$AnimationPlayer.play("Burn")
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
		velocity.y = JUMP_VELOCITY
	# State 1
	if Input.is_key_pressed(KEY_X):
		fireball()
	if Input.is_key_pressed(KEY_Z):
		squashed()
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_direction_flipped(velocity.x) or (current_direction == 0 and velocity.x < 0):
			self.scale.x = -self.scale.x
		current_direction = velocity.x
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
