extends Area2D

const SPEED = 900.0

var velocity = 0
@export var end_pos : Vector2

func _ready():
	pass

func _physics_process(delta):
	if not position.y >= end_pos.y:
		velocity += gravity*delta
		position.y += velocity*delta
	else:
		position = end_pos


func _on_body_entered(body):
	if body.name == "Rana":
		body.squash()
