extends Area2D

var dropped = 0
var velocity = 0
var acceleration = 1200
@export var end_pos : Vector2

func _ready():
	$Sprite2D.visible = false

func _physics_process(delta):
	if dropped:
		if not position.y >= end_pos.y:
			velocity += acceleration * delta
			position.y += velocity * delta
		else:
			position = end_pos


func _on_body_entered(body):
	if body.name == "Rana":
		body.state = 3
		get_parent().tress_flip()

func _on_area_2d_body_entered(body):
	if body.name == "Rana":
		body.handle_anvil()
		$Timer.start()
		$Sprite2D.visible = true
		get_parent().tress_drop()


func _on_timer_timeout():
	dropped = true
