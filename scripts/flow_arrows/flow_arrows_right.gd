# flow_arrows_right.gd
extends Area3D
class_name FlowArrowsRight

func _on_body_entered(body):	
	#report(body," entered my area.")
	if body is Ball: 
		var entry_direction = body.global_transform.origin - global_transform.origin 
		# Check the entry direction to apply force accordingly 
		var yx = body.linear_velocity.x
		body.linear_velocity.y *= 0.5
		if entry_direction.x > 0: 
			# Entered from the left
			# give it a boost			
			body.apply_central_impulse(Vector3(-yx, 0, 0))
		else: 
			# Entered from the right			
			# add an impulse that is opposite its linear_velocity.x
			# make it bounce
			body.apply_central_impulse(Vector3(5, 0, 0))
		#print("RigidBody3D entered from direction: ", entry_direction)	

func _on_body_exited(_body):
	#report(body, " left my area.")
	pass
	
func report(body,event_string):
	if body is Ball:
		print("Ball " + body.name + event_string)
	else:
		print("Body " + body.name + event_string)
