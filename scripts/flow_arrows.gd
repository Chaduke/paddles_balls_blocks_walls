# flow_arrows.gd

extends Area3D

func _on_body_entered(body):
	if body.name =="ball":
		if rotation.z == 0:
			#  push the ball up
			body.linear_velocity.y += 10
		else:
			# push the ball down
			body.linear_velocity.y -= 10

func _on_body_exited(body):
	pass # Replace with function body.
