extends StaticBody2D

const SPEED = 900.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 0.4

func _ready():
	pass

func _physics_process(delta):
	constant_linear_velocity.y += gravity * delta

	move_and_collide(constant_linear_velocity)
