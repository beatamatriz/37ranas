extends StaticBody2D

var detached = false
var velocity = 0
var acceleration = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fall():
	detached = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if detached:
		velocity += acceleration*delta
		position.y += velocity*delta
		move_and_collide(Vector2(0, velocity))
