# block_magnet.gd
extends StaticBody3D
class_name BlockMagnet

var explosion_scene = preload("res://scenes/explosions/block_explosion_magnet.tscn")
var block_magnet_cracked_scene = preload("res://scenes/blocks/block_magnet_cracked.tscn")
var current_ball = null

@export var influence_x = 10
@export var influence_y = 10
@export var leave_cracked = false
@export var magnetic_force = 10

func _process(delta: float) -> void:
	if current_ball:
		var diff = current_ball.position - position
		current_ball.velocity.x += diff.x * magnetic_force * delta
		current_ball.velocity.y += diff.y * magnetic_force * delta
		
func _on_magnetic_influence_body_entered(body):
	if body is Ball:
		if body.position.x > position.x:
			body.linear_velocity.x += influence_x
		else:
			body.linear_velocity.x -= influence_x
		if body.position.y > position.y:
			body.linear_velocity.y += influence_y
		else:
			body.linear_velocity.y -= influence_y

func _on_tree_exiting():
	if not Global.creating_thumbnails and not Global.quitting:
		# add explosion	
		var new_explosion = explosion_scene.instantiate()
		new_explosion.position = global_position
		GameStateManager.main_scene.add_child.call_deferred(new_explosion)
		if leave_cracked:
			var cracked = block_magnet_cracked_scene.instantiate()
			cracked.position = position 
			cracked.influence_x = influence_x * 0.5
			cracked.influence_y = influence_y * 0.5
			GameStateManager.main_scene.stage.add_child.call_deferred(cracked)

func _on_magnetic_influence_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		current_ball = area
		#if area.position.x > position.x:
			#area.velocity.x += influence_x * 0.5
		#else:
			#area.velocity.x -= influence_x * 0.5
		#if area.position.y > position.y:
			#area.velocity.y += influence_y * 0.5
		#else:
			#area.velocity.y -= influence_y * 0.5

func _on_magnetic_influence_area_exited(area: Area3D) -> void:
	if area == current_ball:
		current_ball = null
