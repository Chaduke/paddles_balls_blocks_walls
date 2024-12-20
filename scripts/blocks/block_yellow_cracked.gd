# block_yellow_cracked.gd
extends Area3D
class_name BlockYellowCracked

var explosion_scene = preload("res://scenes/explosions/block_explosion_yellow.tscn")

func _on_body_entered(body):
	if body is Ball:
		explode_and_exit()	
		
func _on_area_entered(area):
	if area is BallClassic:
		explode_and_exit()

func explode_and_exit():	
	var new_explosion = explosion_scene.instantiate()
	new_explosion.position = global_position	
	Global.get_main().add_child.call_deferred(new_explosion)
	queue_free()	
