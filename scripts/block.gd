# block.gd
extends StaticBody3D

var new_block_scene = preload("res://scenes/block_yellow_cracked.tscn")

func _on_tree_exiting():
	var new_instance = new_block_scene.instantiate()
	new_instance.position = position
	var main_scene = get_tree().root.get_child(1)
	var stage = main_scene.get_node("stage")
	stage.add_child(new_instance)
