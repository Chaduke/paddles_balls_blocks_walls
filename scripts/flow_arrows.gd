extends Area3D

func _on_body_entered(body):
	if body.name =="ball":
		if rotation.z !=0:
			#  push the ball downwards
			body.linear_velocity.y -= 5
		else:
			# push the ball upwards
			body.linear_velocity.y += 5
