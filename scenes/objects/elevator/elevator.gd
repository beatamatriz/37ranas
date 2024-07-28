extends CharacterBody2D

@export var upper_floor : Vector2
@export var base_floor : Vector2 
@export var decay : float = 0.5

var move = 0
var state = 0

func exp_decay(a, b, decay, dt):
	return b + (a-b)*exp(-decay*dt)
	
func move_up(delta, dc):
	position = exp_decay(position, upper_floor, dc, delta)

func move_down(delta, dc):
	position = exp_decay(position, base_floor, dc, delta)

func _physics_process(delta):
	if move == 1 and state == 1:
		move_up(delta, self.decay)
	if move == -1 and state == 2:
		move_down(delta, min(1, 1.75 * self.decay))
	if move == 1 and state == 3:
		move_up(delta, min(1, 1.75 * self.decay))


func _on_area_2d_body_entered(body):
	if body.name == "Rana":
		$Timer.start()

func _on_timer_timeout():
	if state == 0:
		state += 1
		move = 1
	if state == 1:
		state += 1
		move = -1
	if state == 2:
		state += 1
		move = 1
