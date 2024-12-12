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

func _on_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		var diff = area.global_position - global_position
		if diff.y > 0 and diff.y > abs(diff.x / 2):
			# its from the top
			area.velocity.y = -area.velocity.y
			queue_free()
		elif diff.y < 0 and abs(diff.y) > abs(diff.x / 2):
			# its from the bottom
			area.velocity.y = -area.velocity.y
		else:
			# its from one of the sides
			area.velocity.x = -area.velocity.x
