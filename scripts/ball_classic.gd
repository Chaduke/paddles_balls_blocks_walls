# ball_classic.gd
extends Area3D
class_name BallClassic

var velocity = Vector3(0,0,0)

func _ready():
	velocity.x = 1
	velocity.y = 10
	$release_sound.play()

func _process(delta):
	position += velocity * delta

func _on_body_entered(body):
	# print(body.name)
	if body is Paddle:
		paddle_collision(body)
	elif body.is_in_group("Blocks"):
		block_collision(body)
	else:
		wall_collision()
		
func wall_collision():
	$wall_sound.play()
	# print("Wall collision occured at " + str(global_position))
	if position.y > 28.5: 
		# ball is at the ceiling
		velocity.y = -velocity.y
		position.y = 28.5-0.01
	else:
		velocity.x = -velocity.x
		if position.x > 11.5: position.x = 11.5-0.01
		if position.x < -17.5: position.x = -17.5+0.01

func paddle_collision(paddle_body):
	var diff = position.x - paddle_body.position.x
	# linear_velocity.y *= 1.4
	velocity.x += diff * 3
	velocity.y= -velocity.y
	$paddle_sound.play()
	
func block_collision(block_body):
	# collision response	
	var diff = global_position - block_body.global_position
	# print("Ball entered from this position : " + str(diff))
	var offset = 0.0
	if diff.y > 0 and diff.y > abs(diff.x / 2):
		# its from the top		
		velocity.y = -velocity.y
		offset = 1 - diff.y
		position.y += offset+0.01
	elif diff.y < 0 and abs(diff.y) > abs(diff.x / 2):
		# its from the bottom
		velocity.y = -velocity.y
		offset = 1 + diff.y
		position.y -= offset+0.01
	else:
		velocity.x = -velocity.x
		if diff.x > 0:
			# right side
			offset = 1.5 - diff.x
			position.x += offset+0.01
		else:
			# left side 
			offset = 1.5 + diff.x
			position.x -= offset+0.01
			
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
