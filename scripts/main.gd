extends Node3D
@onready var paddle = $paddle
var balls = []
var ball_scene = preload("res://scenes/ball.tscn")
var balls_left = 10
@onready var stage = $stage
@onready var camera = $Camera3D
var blocks
var time_label
var stage_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var blocks_node = "blocks_" + str(stage_number)
	blocks = stage.get_node(blocks_node)
	time_label = stage.get_node("time_label")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if camera.position.z < 0:
		camera.position.z += 2	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("spawn_ball"):
		spawn_ball()
		
	# balls loop
	for ball in balls: 
		if ball.position.y < 0: # Check if the ball has left the screen 
			ball.queue_free() 
			balls.erase(ball) # Remove from the list break # Exit loop to prevent errors from modifying the array while iterating	
	if blocks.get_child_count() == 0:
		# reset the level for now
		get_tree().reload_current_scene()
		
func spawn_ball():
	if not time_label.game_started:
		time_label.game_started = true
	var spare_balls = stage.get_node("spare_balls")
	if spare_balls.get_child_count() > 0:
		var spare_ball = spare_balls.get_child(0)
		spare_ball.queue_free()
		balls_left-=1
		var ball_instance = ball_scene.instantiate()
		ball_instance.position = paddle.position + Vector3(0,5,0)
		ball_instance.linear_velocity += Vector3(3,40,0)
		balls.append(ball_instance) 
		add_child(ball_instance)
