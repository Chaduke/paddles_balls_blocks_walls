# block_pink_cracked.gd
extends Area3D
class_name BlockPinkCracked

var explosion_scene = preload("res://scenes/explosions/block_explosion_pink.tscn")
var timed_score_scene = preload("res://scenes/timed_labels/timed_score_label.tscn")
@export var score_value = 5

func _on_body_entered(body):
	if body is Ball:
		explode_and_exit()	

func _on_area_entered(area):
	if area is BallClassic:
		explode_and_exit()

func explode_and_exit():
	var main_scene = get_tree().root.get_child(2)
	var new_explosion = explosion_scene.instantiate()
	new_explosion.position = global_position	
	main_scene.add_child.call_deferred(new_explosion)
	
	var timed_score = timed_score_scene.instantiate()
	timed_score.position = global_position
	timed_score.position.z += 1
	timed_score.set_score(score_value)
	GameStateManager.main_scene.add_child.call_deferred(timed_score)
	
	queue_free()
