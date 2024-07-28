extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.get_parent().visible = true
	self.visible = true
	$Timer.start()
	pass # Replace with function body.



func _process(delta):
	pass


func _on_timer_timeout():
	self.get_parent().visible = false
	self.queue_free()
