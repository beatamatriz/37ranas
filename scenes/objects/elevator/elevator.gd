extends CharacterBody2D

@export var upper_floor : Vector2
@export var base_floor : Vector2 
@export var decay : float = 0.5

const roof_y = -6947
const basement_y = 789

var move = 1
var start = false

func exp_decay(a, b, decay, dt):
	return b + (a-b)*exp(-decay*dt)
	
func move_up(delta, dc):
	if position.y > roof_y:
		position = exp_decay(position, upper_floor, dc, delta)
	else:
		$EasterEggTimer.start()
		move = 2
		start = false

func move_down(delta, dc):
	if position.y < basement_y:
		position = exp_decay(position, base_floor, dc, delta)
	else:
		$EasterEggTimer.start()
		move = 3
		start = false

func _physics_process(delta):
	if start and move == 1:
		move_up(delta, self.decay)
	if start and move == 2:
		move_down(delta, max(0.5, 0.75 * self.decay))
	if start and move == 3:
		move_up(delta, max(0.5, 0.75 * self.decay))

func _on_area_2d_body_entered(body):
	if body.name == "Rana":
		$Timer.start()

func _on_timer_timeout():
	start = true

func _on_easter_egg_timer_timeout():
	start = true
