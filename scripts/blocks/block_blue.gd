# block_blue.gd
extends StaticBody3D
class_name BlockBlue 

var explosion_scene = preload("res://scenes/explosions/block_blue_cracked_explosion.tscn")
var block_blue_cracked_scene = preload("res://scenes/blocks/block_blue_cracked.tscn")
var timed_score_scene = preload("res://scenes/timed_labels/timed_score_label.tscn")
@export var score_value = 15

func _on_tree_exiting():
	if not Global.creating_thumbnails and not Global.quitting:
		var new_explosion = explosion_scene.instantiate()
		new_explosion.position = global_position	
		GameStateManager.main_scene.add_child.call_deferred(new_explosion)
		var new_block = block_blue_cracked_scene.instantiate()
		new_block.position = position
		GameStateManager.main_scene.stage.current_blocks.add_child.call_deferred(new_block)
		
		var timed_score = timed_score_scene.instantiate()
		timed_score.position = global_position
		timed_score.position.z += 1
		timed_score.set_score(score_value)
		GameStateManager.main_scene.add_child.call_deferred(timed_score)
