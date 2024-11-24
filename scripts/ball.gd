extends RigidBody3D
@onready var bounce = $bounce
@onready var block = $block
@onready var wall = $wall

func _on_body_exited(body):
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
	linear_velocity.y *= 1.1
	linear_velocity.x += diff * 2
	bounce.play()
	
func block_collision(block_body):
	block.play()
	var block_model = block_body.get_child(1)
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
	else:
		# catch all for other block types
		block_body.queue_free()
	linear_velocity *= 1.1
