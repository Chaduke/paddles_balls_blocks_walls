# flow_arrows_lr.gd
extends Area3D

func _on_body_entered(body):
	if body.name =="ball":
		if rotation.z ==0:
			#  push the ball right
			body.linear_velocity.x += 10
		else:
			# push the ball left
			body.linear_velocity.x -= 10
