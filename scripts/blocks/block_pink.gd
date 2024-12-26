# block_pink.gd
extends StaticBody3D
class_name BlockPink

@export var item_type : String = "Random" 
var item_scene = preload("res://scenes/pickup_item.tscn")
var explosion_scene = preload("res://scenes/explosions/block_explosion_pink.tscn")
var block_pink_cracked_scene = preload("res://scenes/blocks/block_pink_cracked.tscn")

func _on_tree_exiting():
	if not Global.creating_thumbnails and not Global.quitting:
		var item_instance = item_scene.instantiate()
		item_instance.position = global_position	
		item_instance.item_type = item_type
		Global.get_main().add_child.call_deferred(item_instance)
		# add explosion		
		var new_explosion = explosion_scene.instantiate()
		new_explosion.position = global_position
		Global.get_main().add_child.call_deferred(new_explosion)
		# add cracked block
		var new_block = block_pink_cracked_scene.instantiate()
		new_block.position = position
		Global.get_stage().current_blocks.add_child.call_deferred(new_block)
