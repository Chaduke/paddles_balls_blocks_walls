extends StaticBody3D

var explosion_scene = preload("res://scenes/block_explosion.tscn")

func _on_block_blue_2_tree_exiting():
	var new_explosion = explosion_scene.instantiate()
	new_explosion.position = position
	new_explosion.position.x -= 18.5
	new_explosion.position.z = -37
	var emitter = new_explosion.find_child("GPUParticles3D")	
	emitter.process_material.color = Color(0,0,1,1)	
	get_tree().root.get_child(1).add_child.call_deferred(new_explosion)
	queue_free()
