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

func _on_body_exited(_body):
	#report(body, " left my area.")
	pass 
	
func report(body,event_string):
	if body is Ball:
		print("Ball " + body.name + event_string)
	else:
		print("Body " + body.name + event_string)
