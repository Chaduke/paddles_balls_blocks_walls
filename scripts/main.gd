extends Node3D

@onready var paddle = $paddle
var balls = []
var ball_scene = preload("res://scenes/ball.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("spawn_ball"):
		spawn_ball()
		
	# balls loop
	for ball in balls: 
		if ball.position.y < 0: # Check if the ball has left the screen 
			ball.queue_free() 
			balls.erase(ball) # Remove from the list break # Exit loop to prevent errors from modifying the array while iterating	

func spawn_ball(): 	
	var ball_instance = ball_scene.instantiate()
	ball_instance.position = paddle.position + Vector3(0,5,0)
	ball_instance.linear_velocity += Vector3(3,40,0)
	balls.append(ball_instance) 
	add_child(ball_instance)

	
