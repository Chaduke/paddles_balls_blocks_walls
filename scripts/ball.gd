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
	# trying out "tapering" the ball speed
	#if linear_velocity.x > top_velocity_x:
		#top_velocity_x = linear_velocity.x
		# print("New high X : " + str(top_velocity_x))
	#if linear_velocity.y > top_velocity_y:
		#top_velocity_y = linear_velocity.y
		# print("New high Y : " + str(top_velocity_y))
	# taper the speed 	
	if linear_velocity.x > 50:
		linear_velocity.x = 50
	if linear_velocity.y > 50:
		linear_velocity.y = 50

func _on_body_exited(body):
	if is_inside_tree():
		# print("Exited " + body.name)	
		if body.name=="paddle":
			paddle_collision(body)		
		elif body.name.begins_with("block"):
			block_collision(body)
		else: 
			wall.play()
			linear_velocity*=1.1
		
func paddle_collision(paddle_body):	
	var diff = position.x - paddle_body.position.x
	linear_velocity.y *= 1.4
	linear_velocity.x += diff * 2
	bounce.play()
	
func block_collision(block_body):	
	var block_model = block_body.get_child(1)
	if block_model.name != "block_metal":
		pass
	if block_model.name=="block_blue":
		if block_model.visible==true:
			# the regular model is visible
			# hide it and show the cracked one
			block_model.visible = false
			var block_model2 = block_body.get_child(2)
			block_model2.visible = true
		else:
			# the cracked model is visible, so remove it
			block_body.queue_free()
	elif block_body.name.begins_with("block_clear"):
		block_body.start_timer()
	else:
		# print("Block body name is " + block_body.name)
		# catch all for other block types
		if block_model.name != "block_metal":
			block_body.queue_free()
		else:
			linear_velocity *= 0.98
	
