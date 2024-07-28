extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.set_disabled(true)

func burn():
	for i in range(1, 5000):
		i = i-0
	$HitBox.set_disabled(false)
	$Timer.start()

func _process(delta):
	pass

func _on_body_entered(body):
	if body.name == "Box" or body.name == "Box2":
		body.burn()


func _on_timer_timeout():
	$HitBox.set_disabled(true)
	self.get_parent().cooldown = false
	$Timer.stop()
