# flow_arrows_left.gd
extends Area3D
class_name FlowArrowsLeft

func _on_body_entered(body):	
	#report(body," entered my area.")
	if body is Ball: 
		var entry_direction = body.global_transform.origin - global_transform.origin 
		#print("Ball entered from direction: ", entry_direction)	
		# Check the entry direction to apply force accordingly 
		if entry_direction.x > 0: 
			# Entered from the left		
			# add an impulse that is opposite its linear_velocity.x
			# ie. make it bounce
			var yx = body.linear_velocity.x
			body.apply_central_impulse(Vector3(-yx, 0, 0))
		else: 
			# Entered from the right	
			# boost it more to the left	
			body.apply_central_impulse(Vector3(-1, 0, 0))

func _on_body_exited(_body):
	#report(body, " left my area.")
	pass 
	
func report(body,event_string):
	if body is Ball:
		print("Ball " + body.name + event_string)
	else:
		print("Body " + body.name + event_string)
