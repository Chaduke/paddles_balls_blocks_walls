# block_blue.gd
extends StaticBody3D
class_name BlockBlue 

var explosion_scene = preload("res://scenes/explosions/block_blue_cracked_explosion.tscn")
var block_blue_cracked_scene = preload("res://scenes/blocks/block_blue_cracked.tscn")

func _on_tree_exiting():	
	#var stage = main_scene.find_child("stage")	
	var new_explosion = explosion_scene.instantiate()
	new_explosion.position = global_position	
	Global.get_main().add_child.call_deferred(new_explosion)
	var new_block = block_blue_cracked_scene.instantiate()
	new_block.position = position
	Global.get_stage().current_blocks.add_child.call_deferred(new_block)
