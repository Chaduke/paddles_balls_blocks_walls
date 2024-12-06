# ball.gd 
class_name Ball extends RigidBody3D

@onready var bounce = $bounce
@onready var block = $block
@onready var wall = $wall

@export var ball_models = {
	1:preload("res://assets/models/ball_small.glb"),
	2:preload("res://assets/models/ball_regular.glb"),
	4:preload("res://assets/models/ball_large.glb"),
	8:preload("res://assets/models/ball_xl.glb")
}

var top_velocity_x = 0
var top_velocity_y = 0

func _process(_delta):
	pass
	# trying out "tapering" the ball speed
	#if linear_velocity.x > top_velocity_x:
		#top_velocity_x = linear_velocity.x
		#print("New high X : " + str(top_velocity_x))
	#if linear_velocity.y > top_velocity_y:
		#top_velocity_y = linear_velocity.y
		#print("New high Y : " + str(top_velocity_y))
	# taper the speed 	
	if linear_velocity.x > 50:
		linear_velocity.x = 50
	if linear_velocity.y > 50:
		linear_velocity.y = 50

func _on_body_exited(body):
	if is_inside_tree():
		if body is Paddle:
			# print("Collided with paddle")
			paddle_collision(body)
		elif body.is_in_group("Blocks"):
			# print("Collided with block - " + body.name)
			block_collision(body)
		else: 
			# print("Collided with " + body.name)
			wall.play()
		
func paddle_collision(paddle_body):
	var diff = position.x - paddle_body.position.x
	# linear_velocity.y *= 1.4
	linear_velocity.x += diff * 3
	bounce.play()
	
func block_collision(block_body):
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
