extends StaticBody3D
class_name BlockGreen

@export var damping_value_x = 0.99
@export var damping_value_y = 0.99

var explosion_scene = preload("res://scenes/explosions/block_green_explosion.tscn")
var seed_scene = preload("res://scenes/blocks/seed.tscn")
var reborn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if reborn:
		$ahh_sound.play()
	
func _on_tree_exiting() -> void:
	if not Global.creating_thumbnails and not Global.quitting:	
		var new_explosion = explosion_scene.instantiate()
		new_explosion.position = global_position	
		Global.get_main().add_child.call_deferred(new_explosion)
		var new_block = seed_scene.instantiate()
		new_block.position = position
		Global.get_stage().current_blocks.add_child.call_deferred(new_block)
	
