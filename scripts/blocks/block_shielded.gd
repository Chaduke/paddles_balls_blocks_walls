extends Area3D
class_name BlockShielded

func _on_body_entered(body):
	# detect incoming ball	
	if body is Ball:
		# my version of a bounce response with Area3D vs Rigidbody
		var diff = body.global_position - global_position
		#print("Ball entered from this position : " + str(diff))
		if diff.y > 0 and diff.y > abs(diff.x / 2):
			# its from the top
			queue_free()
		elif diff.y < 0 and abs(diff.y) > abs(diff.x / 2):
			# its from the bottom
			body.apply_central_impulse(Vector3(0,-body.linear_velocity.y,0))
		else:
			# its from one of the sides
			body.apply_central_impulse(Vector3(-body.linear_velocity.x,0,0))
