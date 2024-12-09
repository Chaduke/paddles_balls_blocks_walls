# block_clear.gd
extends StaticBody3D
class_name BlockClear 

var ball_scene = preload("res://scenes/ball.tscn")

var current_ball = 0
@export var total_balls = 1

func start_timer():	
	call_deferred("disable_collision")	
	if total_balls == 1:
		release_ball()
		queue_free()
	else:
		#print("Timer Started...")
		release_ball()
		$Timer.start()

func disable_collision():
	$CollisionShape3D.disabled = true
	
func release_ball():
	var main_scene = get_tree().root.get_child(2)
	var ball_instance = main_scene.create_ball_instance()
	ball_instance.position = global_transform.origin
	var rng = RandomNumberGenerator.new() 
	rng.randomize() 
	var r = rng.randf_range(-10,10)
	if Global.default_ball_mode:
		ball_instance.linear_velocity.x += r
		ball_instance.linear_velocity.y += 10
	else:
		ball_instance.velocity.x = r
		ball_instance.velocity.y = 20
	main_scene.balls.append(ball_instance) 
	main_scene.add_child.call_deferred(ball_instance)

func _on_timer_timeout():
	if (current_ball < total_balls):
		release_ball()
		current_ball+=1
		#print("Released ball " + str(current_ball))
		if current_ball == total_balls:
			queue_free()
