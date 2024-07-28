extends Area2D

var rana : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Rana":
		$Tutorial2.visible = true
		rana = body
		for child in get_children():
			if child is StaticBody2D:
				child.fall()
		$Timer.start()

func _on_timer_timeout():
	$AudioStreamPlayer2D.play()
	rana.joist_fall = true
