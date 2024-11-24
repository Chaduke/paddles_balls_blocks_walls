extends CharacterBody3D
@export var item_type: String = "Random"
@onready var paddle = $paddle

var state
var start_position

func _ready():
	state = 0	
	start_position = position

func _process(_delta):
	if state == 0:
		move_up()
	elif state == 1:
		move_down()
		check_paddle()
	else:
		move_right()

func move_up():
	if position.y < start_position.y + 2:
		position.y += 0.1
	else:
		state = 1
func move_down():
	if position.y > 0:
		position.y -= 0.1
	else:
		queue_free()	
func move_right():
	if position.x < 32:
		position.x += 0.1
func check_paddle():
	pass
	
