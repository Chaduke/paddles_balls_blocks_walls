# block_pink.gd
extends StaticBody3D
class_name BlockPink

@export var item_type : String = "Random" 
var item_scene = preload("res://scenes/pickup_item.tscn")
var explosion_scene = preload("res://scenes/explosions/block_explosion_pink.tscn")
var block_pink_cracked_scene = preload("res://scenes/blocks/block_pink_cracked.tscn")

func _on_tree_exiting():
	var main_scene = get_tree().root.get_child(2)
	var item_instance = item_scene.instantiate()
	item_instance.position = global_position	
	item_instance.item_type = item_type
	main_scene.add_child.call_deferred(item_instance)
	# add explosion	
	var stage = main_scene.find_child("stage")	
	var new_explosion = explosion_scene.instantiate()
	new_explosion.position = global_position
	main_scene.add_child.call_deferred(new_explosion)
	# add cracked block
	var new_block = block_pink_cracked_scene.instantiate()
	new_block.position = position
	stage.current_blocks.add_child.call_deferred(new_block)
	
