# block_blue_cracked.gd
extends Area3D
class_name BlockBlueCracked

var explosion_scene = preload("res://scenes/explosions/block_explosion_blue.tscn")

func _on_body_entered(body):
	if body is Ball:
		var main_scene = get_tree().root.get_child(2)
		var new_explosion = explosion_scene.instantiate()
		new_explosion.position = global_position	
		main_scene.add_child.call_deferred(new_explosion)
		queue_free()
