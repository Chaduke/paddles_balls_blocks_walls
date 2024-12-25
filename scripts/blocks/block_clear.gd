# block_clear.gd
extends StaticBody3D
class_name BlockClear 

var ball_scene = preload("res://scenes/ball.tscn")

var timed_score_scene = preload("res://scenes/timed_labels/timed_score_label.tscn")
@export var score_value = 20

var current_ball = 0
@export var total_balls = 1

func _ready() -> void:
	if total_balls > 1:
		$block_clear_model.hide()
		$block_clear_model_2.show()
		
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
	var ball_controller = Global.get_main().get_node("ball_controller")
	var ball_instance = ball_controller.create_ball_instance()
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
	ball_instance.released = true
	ball_controller.balls.append(ball_instance) 
	Global.get_main().add_child.call_deferred(ball_instance)
	
	var timed_score = timed_score_scene.instantiate()
	timed_score.position = global_position
	timed_score.position.z += 1
	timed_score.set_score(score_value)
	Global.get_main().add_child.call_deferred(timed_score)

func _on_timer_timeout():
	if (current_ball < total_balls):
		release_ball()
		current_ball+=1
		#print("Released ball " + str(current_ball))
		if current_ball == total_balls:
			queue_free()
