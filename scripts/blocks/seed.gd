extends Area3D
class_name Seed

var green_block_scene = preload("res://scenes/blocks/block_green.tscn")
var seed_explosion = preload("res://scenes/explosions/seed_explosion.tscn")
var timed_score_scene = preload("res://scenes/timed_labels/timed_score_label.tscn")
@export var score_value = 25

func _on_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		explode_and_exit()
		
func _on_body_entered(body: Node3D) -> void:
	if body is Ball:
		explode_and_exit()
		
func explode_and_exit():	
	var new_explosion = seed_explosion.instantiate()
	new_explosion.position = global_position	
	Global.get_main().add_child.call_deferred(new_explosion)	
	
	var timed_score = timed_score_scene.instantiate()
	timed_score.position = global_position
	timed_score.position.z += 1
	timed_score.set_score(score_value)
	timed_score.get_node("Label3D").modulate = Color(1.0,0.0,0.0,1.0)
	Global.get_main().add_child.call_deferred(timed_score)
	
	queue_free()

func _on_germination_timer_timeout() -> void:
	#respawn a green block	
	var new_block = green_block_scene.instantiate()
	new_block.reborn = true 
	new_block.position = position
	Global.get_stage().current_blocks.add_child.call_deferred(new_block)
	
	
	
	queue_free()
