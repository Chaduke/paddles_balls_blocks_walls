extends StaticBody3D
class_name BlockGreen

@export var damping_value_x = 0.99
@export var damping_value_y = 0.99

var explosion_scene = preload("res://scenes/explosions/block_green_explosion.tscn")
var seed_scene = preload("res://scenes/blocks/seed.tscn")
var reborn = false
var timed_score_scene = preload("res://scenes/timed_labels/timed_score_label.tscn")
@export var score_value = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if reborn:
		$ahh_sound.play()
	
func _on_tree_exiting() -> void:
	if not Global.creating_thumbnails and not Global.quitting:	
		var new_explosion = explosion_scene.instantiate()
		new_explosion.position = global_position	
		GameStateManager.main_scene.add_child.call_deferred(new_explosion)
		var new_block = seed_scene.instantiate()
		new_block.position = position
		GameStateManager.main_scene.stage.current_blocks.add_child.call_deferred(new_block)
		
		var timed_score = timed_score_scene.instantiate()
		timed_score.position = global_position
		timed_score.position.z += 1
		timed_score.set_score(score_value)
		GameStateManager.main_scene.add_child.call_deferred(timed_score)
	
