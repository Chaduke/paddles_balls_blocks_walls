# block_yellow.gd
extends StaticBody3D
class_name BlockYellow 

var explosion_scene = preload("res://scenes/explosions/block_yellow_cracked_explosion.tscn")
var block_yellow_cracked_scene = preload("res://scenes/blocks/block_yellow_cracked.tscn")

func _on_tree_exiting():	
	var new_explosion = explosion_scene.instantiate()
	new_explosion.position = global_position	
	Global.get_main().add_child.call_deferred(new_explosion)
	var new_block = block_yellow_cracked_scene.instantiate()
	new_block.position = position
	Global.get_stage().current_blocks.add_child.call_deferred(new_block)
