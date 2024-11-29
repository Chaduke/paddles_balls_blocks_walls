extends StaticBody3D

func _on_magnetic_influence_body_entered(body):
	if body.name.begins_with("ball"):
		if body.position.x > position.x:
			body.linear_velocity.x += 10
		else:
			body.linear_velocity.x -= 10
		if body.position.y > position.y:
			body.linear_velocity.y += 10
		else:
			body.linear_velocity.y -= 10
