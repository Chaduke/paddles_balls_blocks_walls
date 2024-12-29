# ball_controller.gd
extends Node

var balls = []
var ball_scene = preload("res://scenes/ball.tscn")
var ball_classic_scene = preload("res://scenes/ball_classic.tscn")
var paddle = null

func _ready():
	paddle = Global.get_main().get_node("paddle")
	#print("Init ball controller")
	#print("Balls list length is " + str(len(balls)))
	
func _process(_delta: float) -> void:
	#if Global.stage_started: check_balls()
	pass
	
func ball_lost(ball):
	#print("Balls list length is " + str(len(balls)))
	#print ("Erasing ball from list")
	balls.erase(ball)
	ball.queue_free()
	# check for game over condition
	#print("Balls list length is " + str(len(balls)))
	if len(balls) == 0:
		if Global.balls_left == 0:
			Global.get_main().game_over()
		elif Global.game_mode == Global.ARCADE:
			Global.get_main().game_ready = false
			Global.get_stage().start_rsg()

func remove_ball_from_paddle():
	# remove the ball from the paddle
	var ball = null
	for child in paddle.get_children():
		if child is BallClassic:
			ball = child
			break
	if ball == null:
		return false
	else:	
		paddle.remove_child(ball)
		Global.get_main().add_child(ball)
		balls.append(ball)
		ball.position  = paddle.global_position + Vector3(0,Global.ball_offset(),0)
		ball.velocity.y = 30
		set_ball_gravity(ball)
		ball.released = true
		return true
		
func set_ball_gravity(ball):
	if Global.gravity_reversed:
		ball.acceleration.y = 20
	else:
		ball.acceleration.y = -15
		
func spawn_ball():
	# spawning the first ball starts the stage
	if not Global.stage_started:
		Global.stage_started = true
		MusicServer.play_music()
			
	# check if it's ok to spawn a ball
	if decrement_balls():
		var ball_instance = create_ball_instance()
		# position the new ball in respect to the paddle 
		
		if Global.default_ball_mode: 
			ball_instance.linear_velocity += Vector3(10,40,0)
		else:
			ball_instance.velocity.x = 2
			ball_instance.velocity.y = 30
			set_ball_gravity(ball_instance)
		# add the new ball to our list and to the main scene 
		balls.append(ball_instance) 
		Global.get_main().add_child(ball_instance)
		var ball_offset = Global.ball_offset() + 0.1
		ball_instance.position = paddle.global_position + Vector3(0,ball_offset,0)
		ball_instance.released = true
		
func attach_ball_to_paddle():
	#print("Attaching ball to paddle")
	if decrement_balls():
		var ball = create_ball_instance()
		paddle.add_child(ball)
		var ball_offset = Global.ball_offset() + 0.02
		ball.position = Vector3(0,ball_offset,0)
		#print("Balls list length is " + str(len(balls)))

func remove_all_balls():
	Global.get_main().get_node("ball_gun_timer").stop()
	for ball in balls:
		ball.queue_free()

func decrement_balls(): 
	var spare_balls = Global.get_stage().get_node("spare_balls")
	if spare_balls.get_child_count() > 0 and not Global.infinite_balls:
		var spare_ball = spare_balls.get_child(0)
		spare_ball.queue_free()
		Global.balls_left-=1
		if Global.balls_left < 0: 
			Global.balls_left = 0
			Global.get_main().get_node("ball_gun_timer").stop()
		return true
	else:
		if Global.infinite_balls:
			return true 
		else:
			return false

func create_ball_instance():
	var ball_instance
	if Global.default_ball_mode:
		ball_instance = ball_scene.instantiate()
	else:
		ball_instance = ball_classic_scene.instantiate()
	clear_existing_mesh_instance(ball_instance)
	add_new_mesh_instance(ball_instance)
	setup_ball_collision(ball_instance)
	return ball_instance

func clear_existing_mesh_instance(ball_instance):
	#print("Attempting to clear ball_model for " + ball_instance.name)
	for child in ball_instance.get_children():
		#print(child.name)
		if child.name.begins_with("ball") or child is MeshInstance3D:
			#print("Freeing model")
			child.queue_free()

func add_new_mesh_instance(ball_instance):
	#print("Attempting to add new ball_model for " + ball_instance.name)
	var new_mesh_instance
	if Global.default_ball_mode:
		new_mesh_instance = ball_instance.ball_models[Global.current_ball_size].instantiate()
	else:
		new_mesh_instance = create_procedural_ball()
	ball_instance.add_child(new_mesh_instance)
	#print("added instance with size " + str(Global.current_ball_size))
	
func create_procedural_ball():
	# Step 1: Create MeshInstance3D and SphereMesh 
	var mesh_instance = MeshInstance3D.new() 
	var sphere_mesh = SphereMesh.new() 
	# Set radius 
	sphere_mesh.radius = Global.current_ball_size / 4.0
	# Set height
	sphere_mesh.height = sphere_mesh.radius * 2
	# Step 2: Assign SphereMesh to MeshInstance3D 
	mesh_instance.mesh = sphere_mesh 
	# Step 3: Create and configure StandardMaterial3D 
	var material = StandardMaterial3D.new() 
	material.albedo_color = Color(1.0,0.5,1.0,1.0) 
	# RGB: 255, 125, 255 (pink)
	material.metallic = 0.3 
	material.roughness = 0.3 
	# Step 4: Assign material to MeshInstance3D 
	mesh_instance.material_override = material
	return mesh_instance
	
func setup_ball_collision(ball_instance):
	# Update collision shape radius 
	if ball_instance.has_node("CollisionShape3D"): 
		var collision_shape = ball_instance.get_node("CollisionShape3D") 
		if collision_shape and collision_shape.shape is SphereShape3D: 
			var sphere_shape = collision_shape.shape as SphereShape3D 
			sphere_shape.radius = Global.current_ball_size / 4.0 - 0.1
		else: 
			print("Error: CollisionShape3D node or SphereShape3D shape not found.")

func update_ball_size():
	#print("Updating ball size to " + str(Global.current_ball_size))	
	for ball_instance in balls:
		clear_existing_mesh_instance(ball_instance)
		add_new_mesh_instance(ball_instance)
		setup_ball_collision(ball_instance)
		
func reverse_gravity():
	#print("Gravity reverse called")
	#print("Ball list size:" + str(len(balls)))
	for ball in balls:
		if ball is BallClassic:
			# make reverse gravity a little more apparent
			ball.acceleration.y = 20
			ball.velocity.y = 5
			#print ("Gravity reversed on ball")
func restore_gravity():
	for ball in balls:
		if ball is BallClassic:
			# make reverse gravity a little more apparent
			ball.acceleration.y = -15
			#print ("Gravity restored on ball")
