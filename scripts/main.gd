extends Node3D
@onready var paddle = $paddle
var balls = []
var ball_scene = preload("res://scenes/ball.tscn")
var balls_left = 10

@onready var stage = $stage
@onready var camera = $Camera3D
var time_label

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	time_label = stage.get_node("time_label")
	# make sure Global stuff is where it needs to be on scene reload
	Global.current_ball_size = 2
	Global.infinite_balls = false
	PhysicsServer3D.area_set_param(get_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, Vector3(0, -1, 0))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if camera.position.z < 0:
		camera.position.z += 4
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("spawn_ball"):
		spawn_ball()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	# balls loop
	for ball in balls: 
		if ball.position.y < 0: # Check if the ball has left the screen 
			ball.queue_free() 
			balls.erase(ball)
			break

func remove_all_balls():
	for ball in balls:
		ball.queue_free() 
		balls.erase(ball)
	
func spawn_ball():
	if camera.position.z < 0:
		return
	if not time_label.game_started:
		time_label.game_started = true
	var spare_balls = stage.get_node("spare_balls")
	if spare_balls.get_child_count() > 0:
		if not Global.infinite_balls:
			var spare_ball = spare_balls.get_child(0)
			spare_ball.queue_free()
			balls_left-=1
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
				sphere_shape.radius = Global.current_ball_size / 4.0 
			else: 
				print("Error: CollisionShape3D node or SphereShape3D shape not found.")		
		ball_instance.position = paddle.position + Vector3(0,1,0)
		ball_instance.linear_velocity += Vector3(2,40,0)
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
