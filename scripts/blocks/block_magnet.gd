# block_magnet.gd
extends StaticBody3D
class_name BlockMagnet

var explosion_scene = preload("res://scenes/explosions/block_explosion_magnet.tscn")

func _on_magnetic_influence_body_entered(body):
	if body is Ball:
		if body.position.x > position.x:
			body.linear_velocity.x += 10
		else:
			body.linear_velocity.x -= 10
		if body.position.y > position.y:
			body.linear_velocity.y += 10
		else:
			body.linear_velocity.y -= 10

func _on_tree_exiting():
	if not Global.creating_thumbnails:
		# add explosion	
		var new_explosion = explosion_scene.instantiate()
		new_explosion.position = global_position
		Global.get_main().add_child.call_deferred(new_explosion)

func _on_magnetic_influence_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		if area.position.x > position.x:
			area.velocity.x += 5
		else:
			area.velocity.x -= 5
		if area.position.y > position.y:
			area.velocity.y += 5
		else:
			area.velocity.y -= 5
