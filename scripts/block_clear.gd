extends StaticBody3D
var ball_scene = preload("res://scenes/ball.tscn")

func _on_tree_exiting():	
	var main_scene = get_tree().root.get_child(1)
	var current_ball_size = main_scene.current_ball_size
	var ball_instance = ball_scene.instantiate()
	ball_instance.position = global_transform.origin
	# print("Ball spawned at " + str(position))
	if ball_instance.has_node("MeshInstance3D"):
		var mesh_instance = ball_instance.get_node("MeshInstance3D")
		if mesh_instance:
			mesh_instance.queue_free()
	var new_mesh_instance = ball_instance.ball_models[current_ball_size].instantiate()
	new_mesh_instance.name="MeshInstance3D"
	ball_instance.add_child(new_mesh_instance)	
	# Update collision shape radius 
	if ball_instance.has_node("CollisionShape3D"): 
		var collision_shape = ball_instance.get_node("CollisionShape3D") 
		if collision_shape and collision_shape.shape is SphereShape3D: 
			var sphere_shape = collision_shape.shape as SphereShape3D 
			sphere_shape.radius = current_ball_size / 4.0 
		else: 
			print("Error: CollisionShape3D node or SphereShape3D shape not found.")
	var rng = RandomNumberGenerator.new() 
	rng.randomize() # Ensure randomness by randomizing the seed 
	var random_int = rng.randi_range(-10,10)
	ball_instance.linear_velocity.x += random_int
	ball_instance.linear_velocity.y += 10
	main_scene.balls.append(ball_instance) 
	main_scene.add_child.call_deferred(ball_instance)
