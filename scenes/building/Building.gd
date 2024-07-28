extends Node2D

var a = 0

func handle_ending():
	$EndingTimer.start()
	$Rana/damn.visible = true
	$Rana/end0.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()

func _process(delta):
	pass

func _on_ending_timer_timeout():
	if a == 0:
		$EndingTimer.start()
		$Rana/end0.visible = false
		$Rana/end1.visible = true
		a = 1
	else:
		get_tree().quit()


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
