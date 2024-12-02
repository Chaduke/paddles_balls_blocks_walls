# main.gd
extends Node3D

var balls = []
var ball_scene = preload("res://scenes/ball.tscn")
var balls_left = 10
var game_ready = false

func _ready():
	set_globals()	
	
func set_globals():
	# after each stage is complete 
	# I call a get_tree().reload_current_scene()
	Global.current_ball_size = 2
	Global.infinite_balls = false
	# set gravity to normal 
	PhysicsServer3D.area_set_param(get_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, Vector3(0, -1, 0))
	if Global.game_started:
		$camera/click_to_begin.visible = false

func _process(_delta):
	if Global.game_started:
		position_camera()
		get_input()
				
	if Global.stage_started:
		process_balls()
	else:
		check_stage_start()
			
func position_camera():
	# this is just an "opening movement" thing so show off the 3D scenery
	if not game_ready:
		if $camera.position.z < 0:
			$camera.position.z += 4
		else:
			game_ready = true
			
func get_input():
	if Input.is_action_pressed("ui_cancel"):
		$main_menu.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	if Input.is_action_just_pressed("spawn_ball") and game_ready:
		spawn_ball()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
			
func process_balls():
	# balls loop
	for ball in balls:
		# Check if the ball has left the screen 
		if ball.position.y < 0:
			balls.erase(ball)
			ball.queue_free()
			# check for game over condition				
			if len(balls) == 0 and balls_left == 0:
				game_over()
			break

func game_over():
	$game_over.visible = true
	Global.stage_started = false
				
func check_stage_start():
	if Input.is_action_pressed("swing_paddle"):
		$game_over.visible = false
		Global.stage_started = true
		get_tree().reload_current_scene()
		$stage.load_stage(Global.current_stage)
			
func remove_all_balls():
	for ball in balls:
		ball.queue_free() 
		balls.erase(ball)
	
func spawn_ball():
	if not Global.stage_started:
		Global.stage_started = true
	var spare_balls = $stage/spare_balls
	if spare_balls.get_child_count() > 0:
		if not Global.infinite_balls:
			var spare_ball = spare_balls.get_child(0)
			spare_ball.queue_free()
			balls_left-=1
			if balls_left < 0: balls_left = 0
		var ball_instance = ball_scene.instantiate()
		if ball_instance.has_node("MeshInstance3D"):
			var mesh_instance = ball_instance.get_node("MeshInstance3D")
			if mesh_instance:
				mesh_instance.queue_free()
		var new_mesh_instance = ball_instance.ball_models[Global.current_ball_size].instantiate()
		new_mesh_instance.name="MeshInstance3D"
		ball_instance.add_child(new_mesh_instance)
		# Update collision shape radius 
		if ball_instance.has_node("CollisionShape3D"): 
			var collision_shape = ball_instance.get_node("CollisionShape3D") 
			if collision_shape and collision_shape.shape is SphereShape3D: 
				var sphere_shape = collision_shape.shape as SphereShape3D 
				sphere_shape.radius = Global.current_ball_size / 4.0 - 0.1
			else: 
				print("Error: CollisionShape3D node or SphereShape3D shape not found.")		
		ball_instance.position = $paddle.position + Vector3(0,1,0)
		ball_instance.linear_velocity += Vector3(5,40,0)
		balls.append(ball_instance) 
		add_child(ball_instance)	
		
func update_ball_size():
	for ball_instance in balls:
		if ball_instance.has_node("MeshInstance3D"):
			var mesh_instance = ball_instance.get_node("MeshInstance3D")
			if mesh_instance:
				mesh_instance.queue_free()
		var new_mesh_instance = ball_instance.ball_models[Global.current_ball_size].instantiate()
		new_mesh_instance.name="MeshInstance3D"		
		ball_instance.add_child(new_mesh_instance)
		# Update collision shape radius 
		if ball_instance.has_node("CollisionShape3D"): 
			var collision_shape = ball_instance.get_node("CollisionShape3D") 
			if collision_shape and collision_shape.shape is SphereShape3D: 
				var sphere_shape = collision_shape.shape as SphereShape3D 
				sphere_shape.radius = Global.current_ball_size / 4.0 
			else: 
				print("Error: CollisionShape3D node or SphereShape3D shape not found.")
