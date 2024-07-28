extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Una")

func _process(delta):
	pass

func tress_flip():
	$AnimationPlayer.play("Una")
	$Sprite2D.scale.x = -1

func tress_drop():
	$AnimationPlayer.play("Dos")

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Rana":
		body.get_parent().handle_ending()
