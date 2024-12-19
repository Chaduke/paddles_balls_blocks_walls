# ball_classic.gd
extends Area3D
class_name BallClassic

var velocity = Vector3(0.0,0.0,0.0)
var acceleration = Vector3(0.0,-10.0,0.0)

var x_velocity_limit = 50
var y_velocity_limit = 50

var top_bounds = 0.0
var left_bounds = 0.0
var right_bounds = 0.0

func _ready():
	if Global.gravity_reversed:
		acceleration.y = 10.0	
	$release_sound.play()
	update_bounds()

func _process(delta):
	limit_ball_velocity()	
	velocity += acceleration * delta
	position += velocity * delta
	bounds_check()
	
func limit_ball_velocity():
	if abs(velocity.x) > x_velocity_limit:
		if velocity.x > 0:
			velocity.x = x_velocity_limit
		else:
			velocity.x = -x_velocity_limit
	if abs(velocity.y) > y_velocity_limit:
		if velocity.y > 0:
			velocity.y = y_velocity_limit
		else:
			velocity.y = -y_velocity_limit

func _on_body_entered(body):
	# print(body.name)
	if body is Paddle:
		paddle_collision(body)
	elif body.is_in_group("Blocks"):
		block_collision(body)
	elif body is Stage:
		wall_collision()
	#else:
		#print_debug("Collided with something other than paddle, block or stage : " + body.name)				
func update_bounds():
	var ball_offset = Global.ball_offset()
	top_bounds = 29.5 - ball_offset
	right_bounds = 12.5 - ball_offset
	left_bounds = -18.5 + ball_offset
	
func bounds_check():
	if position.x < left_bounds: 
		position.x = left_bounds
		velocity.x = abs(velocity.x)
		#print("Corrected left bounds")
	if position.x > right_bounds: 
		position.x = right_bounds
		velocity.x = -abs(velocity.x)
		#print("Corrected right bounds")
	if position.y > top_bounds: 
		position.y = top_bounds
		velocity.y = -abs(velocity.y)
		#print("Corrected top bounds")

func wall_collision():
	$wall_sound.play()
	# print("Stage collision occured at " + str(global_position))
	update_bounds()
	velocity *= 0.95
	# print("T : " + str(top_bounds) + " R : " + str(right_bounds) + " L : " + str(left_bounds))
	if position.y > top_bounds: 
		# ball is at the ceiling
		velocity.y = -abs(velocity.y)
		position.y = top_bounds-0.01
		# print("Velocity Y adjusted to : " + str(velocity.y))
		# print("Position Y adjusted to : " + str(position.y))
	else:		
		# print("Velocity  X adjusted to : " + str(velocity.x))
		if position.x > right_bounds: 
			position.x = right_bounds-0.01
			velocity.x = -abs(velocity.x)
		if position.x < left_bounds: 
			position.x = left_bounds+0.01
			velocity.x = abs(velocity.x)
		# print("Position X adjusted to : " + str(position.x))

func paddle_collision(paddle_body):
	var diff = position.x - paddle_body.position.x
	velocity.x += diff * 3
	# check if paddle is in "upswing"
	if paddle_body.upswing:
		velocity.y= -velocity.y * 1.5
	else:
		velocity.y= -velocity.y
	position.y = paddle_body.position.y + Global.ball_offset() + 0.1
	$paddle_sound.play()

func block_collision_response(block_position):
	var diff = global_position - block_position
	# print("Ball entered from this position : " + str(diff))
	var offset = 0.0
	if diff.y > 0 and diff.y > abs(diff.x / 2):
		# its from the top		
		velocity.y = -velocity.y
		offset = Global.ball_offset() - diff.y
		position.y += offset+0.01
	elif diff.y < 0 and abs(diff.y) > abs(diff.x / 2):
		# its from the bottom
		velocity.y = -velocity.y
		offset = Global.ball_offset() + diff.y
		position.y -= offset+0.01
	else:
		velocity.x = -velocity.x
		if diff.x > 0:
			# right side
			offset = Global.ball_offset() + 0.5 - diff.x
			position.x += offset+0.01
		else:
			# left side 
			offset = Global.ball_offset() + 0.5 + diff.x
			position.x -= offset+0.01
			
func block_collision(block_body):
	if Global.current_ball_size==4 and block_body is BlockYellow:
		pass
		# don't bounce
	else:
		block_collision_response(block_body.global_position)
	# we have to destroy our StaticBody3D types from here
	# for some reason there's no signal to allow it to destroy itself on collision
	# Area3Ds however, like the cracked blocks, have an _on_body_entered signal	
	if block_body is BlockBlue:
		block_body.queue_free()
	elif block_body is BlockYellow:
		block_body.queue_free()
	elif block_body is BlockPink:
		block_body.queue_free()
	elif block_body is BlockClear:
		block_body.start_timer()
	elif block_body is BlockMagnet:
		block_body.queue_free()
	elif block_body is BlockMetal:
		# reduce the chances of ball getting stuck bouncing between
		# metal blocks and / or walls
		velocity.x *= block_body.damping_value_x
		velocity.y *= block_body.damping_value_y
	elif block_body is BlockGreen:
		# make sure to spawn a seed
		velocity.x *= block_body.damping_value_x
		velocity.y *= block_body.damping_value_y
		block_body.queue_free()
		
