# main.gd
extends Node3D

var balls = []
var ball_scene = preload("res://scenes/ball.tscn")
var ball_classic_scene = preload("res://scenes/ball_classic.tscn")
var balls_left = 10
var game_ready = false
var camera_ready = false
var elapsed_time = 0.0

func _ready():	
	set_globals()
	if not Global.game_started:
		$main_menu.show()
		get_tree().paused = true
		
func set_globals():
	# after each stage is complete 
	# I call a get_tree().reload_current_scene()
	Global.current_ball_size = 2
	Global.infinite_balls = false
	Global.stage_started = false
	# set gravity to normal 
	PhysicsServer3D.area_set_param(get_world_3d().space, 
	PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, 
	Vector3(0, -1, 0))
	Global.deactivate_all_slots()
	# make sure inputs are setup properly based on platform
	os_specific_inits()	

func os_specific_inits():
	# web build
	if OS.get_name() == "Web":
		var escape_event = InputEventKey.new() 
		escape_event.keycode = KEY_ESCAPE
		var tab_event = InputEventKey.new() 
		tab_event.keycode = KEY_TAB
		InputMap.action_erase_event("ui_cancel",escape_event)
		InputMap.action_add_event("ui_cancel", tab_event)
		
func _process(delta):
	elapsed_time+=delta
	if Global.game_started:
		position_camera()
		get_input()
		if Global.stage_started:
			process_balls()
			
func position_camera():
	# this is just an "opening movement" thing so show off the 3D scenery
	if not camera_ready:
		if $camera.position.z < 0:
			$camera.position.z += 4
		else:
			camera_ready = true
			$stage.start_rsg()

func get_input():
	if Input.is_action_just_pressed("ui_cancel"):
		if elapsed_time > 0.1 : toggle_main_menu()
	if Input.is_action_just_pressed("spawn_ball") and game_ready:		
		spawn_ball()
	if Input.is_action_just_pressed("settings"):
		if elapsed_time > 0.1 : toggle_settings()
	if Input.is_action_just_pressed("reset"):
		restart_stage()
	if Input.is_action_just_pressed("ball_gun"):
		$ball_gun_timer.start()
	if Input.is_action_just_pressed("select_stage"):
		toggle_stage_selection()
	if Input.is_action_just_pressed("help_menu"):
		toggle_help_menu()

func toggle_stage_selection():
	if OS.get_name() == "Web":
		$stage_selection_menu_web.show()
		$stage_selection_menu_web.elapsed_time = 0.0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	else:
		$stage_selection_menu_web.show()
		$stage_selection_menu_web.elapsed_time = 0.0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func toggle_help_menu():
	if $help_menu.active:
		$camera.lerping = true
		$camera.target_position = Vector3(0,15,0)
		$help_menu.active = false
	else:
		$camera.lerping = true
		$camera.target_position = Vector3(0,45,0)
		$help_menu.active = true		

func toggle_main_menu():
	$main_menu.show()
	$main_menu.elapsed_time = 0.0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
		
func spawn_ball():
	# spawning the first ball starts the stage
	if not Global.stage_started:
		Global.stage_started = true
		MusicServer.play_music()
	# check if it's ok to spawn a ball
	if decrement_balls():
		var ball_instance = create_ball_instance()
		# position the new ball in respect to the paddle 
		var ball_offset = Global.ball_offset() + 0.1
		ball_instance.position = $paddle.position + Vector3(0,ball_offset,0)
		if Global.default_ball_mode: 
			ball_instance.linear_velocity += Vector3(10,40,0)
		else:
			ball_instance.velocity.x = 2
			ball_instance.velocity.y = 30
		# add the new ball to our list and to the main scene 
		balls.append(ball_instance) 
		add_child(ball_instance)
			
func toggle_settings():
		$settings_menu.show()
		$settings_menu.elapsed_time = 0.0
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
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
	$game_over_menu.show()
	set_globals()
	get_tree().paused = true
	Global.stage_started = false	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func restart_stage():
	# called from game_over_menu.gd
	$game_over_menu.hide()
	get_tree().paused = false
	get_tree().reload_current_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
func remove_all_balls():
	for ball in balls:
		balls.erase(ball)
		ball.queue_free()

func decrement_balls(): 
	var spare_balls = $stage/spare_balls
	if spare_balls.get_child_count() > 0 and not Global.infinite_balls:
		var spare_ball = spare_balls.get_child(0)
		spare_ball.queue_free()
		balls_left-=1
		if balls_left < 0: 
			balls_left = 0
			$ball_gun_timer.stop()
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
	material.albedo_color = Color(1, 0.49, 1) 
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

func _on_ball_gun_timer_timeout():
	spawn_ball()
