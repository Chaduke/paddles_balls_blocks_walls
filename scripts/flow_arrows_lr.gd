# flow_arrows_lr.gd
extends Area3D
var ball_body
var ball_active = false

func _process(_delta):
	if ball_active:
		if rotation.z == 0:
			#  push the ball right
			#ball_body.linear_velocity.x += 0.1
			pass
		else:
			# push the ball left
			#ball_body.linear_velocity.x -= 0.1
			pass
func _on_body_entered(body):
	if body.name =="ball":
		ball_body = body
		ball_active = true
		if rotation.z == 0:
			#  push the ball right
			body.linear_velocity.x += 10
		else:
			# push the ball left
			body.linear_velocity.x -= 10
			
func _on_body_exited(body):
	if body.name =="ball":
		ball_active = false
