extends CharacterBody3D
@export var item_type: String = "Random"
@onready var collision_shape_3d = $CollisionShape3D
@onready var pickup_timer = $pickup_timer

var state
var start_position
var elapsed_time = 0.0
var timer = 10

func _ready():
	state = 0	
	start_position = position

func _process(delta):
	if state == 0:
		move_up()
	elif state == 1:
		move_down()		
	elif state == 2:
		move_right()
	else:
		elapsed_time+=delta
		var secs = int(elapsed_time) % 60
		pickup_timer.text = str(timer - secs)
		if secs == timer:
			queue_free()

func move_up():	
	if position.y < start_position.y + 2:
		position.y += 0.1
	else:
		state = 1
		
func move_down():
	if position.y > 0:
		var collision = move_and_collide(Vector3(0,-0.1,0))
		if collision:
			collision_shape_3d.disabled = true
			state = 2
			if item_type == "Grower":
				# change the paddle size if possible
				pass
	else:
		queue_free()
		
func move_right():
	if position.x < 15:
		position.x += 0.3
	else: 
		state = 3
		pickup_timer.visible = true
		
