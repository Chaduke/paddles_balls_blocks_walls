# flow_arrows_down.gd
extends Area3D
class_name FlowArrowsDown

func _on_body_entered(body):	
	#report(body," entered my area.")
	if body is Ball: 
		var entry_direction = body.global_transform.origin - global_transform.origin 
		# Check the entry direction to apply force accordingly 
		if entry_direction.y > 0: 
			# Entered from the top 			
			body.apply_central_impulse(Vector3(0, -1, 0))
		else: 
			# Entered from the bottom 
			# add an impulse that is opposite its linear_velocity.y
			var yv = body.linear_velocity.y
			body.apply_central_impulse(Vector3(0, -yv, 0))
			#print("RigidBody3D entered from direction: ", entry_direction)	

func _on_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		var diff_y = area.global_transform.origin.y - global_transform.origin.y
		if diff_y < 0:
			# ball (area) y location is less than these arrows
			# resulting a negative value for diff_y
			# and meaning that the ball is lower on screen than the arrows
			# meaning it entered from below
			# we don't want the ball to move against the arrows direction
			# so we reverse the ball velocity
			area.velocity.y = -area.velocity.y
			# SKIP THIS REPOSITION FOR DOWN ARROWS 
			# ASS IT CAUSES THE BALL TO SHOOT STRAIGHT DOWN REALLY FAST
			# get the radius of the ball depending on its size 
			# then add the absolute value of diff_y to it		
			# var offset = Global.ball_offset() + abs(diff_y)
			# subtract the offset from the balls y position 
			# to place the ball outside the collision zone
			# and avoid any kind of double collisions
			#area.position.y -= offset
			
func report(body,event_string):
	if body is Ball:
		print("Ball " + body.name + event_string)
	else:
		print("Body " + body.name + event_string)
