extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.set_disabled(true)
	pass # Replace with function body.	

func burn():
	$HitBox.set_disabled(false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	body.burn()
	pass # Replace with function body.
