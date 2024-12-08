# ball_classic.gd
extends Area3D
class_name BallClassic

var velocity = Vector3(0,0,0)

func _ready():
	velocity.x = 1
	velocity.y = 10
	$ball_release_sound.play()

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
	if position.y > 28 and position.x > -18.5 and position.x < 12:
		# ball is at the ceiling
		velocity.y = -velocity.y
	else:
		velocity.x = -velocity.x

func paddle_collision(paddle_body):
	var diff = position.x - paddle_body.position.x
	# linear_velocity.y *= 1.4
	velocity.x += diff * 3
	velocity.y= -velocity.y
	$paddle_sound.play()
	
func block_collision(block_body):
	# we have to destroy our StaticBody3D types from here
	# for some reason there's no signal to allow it to destroy itself on collision
	# Area3Ds however, like the cracked blocks, have an _on_body_entered signal
	velocity.y= -velocity.y
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
