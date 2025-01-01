# block_magnet_cracked.gd
extends Area3D
class_name BlockMagnetCracked

var explosion_scene = preload("res://scenes/explosions/block_explosion_magnet.tscn")
@export var influence_x = 5
@export var influence_y = 5

func _on_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		explode_and_exit()

func _on_body_entered(body: Node3D) -> void:
	if body is Ball:
		explode_and_exit()

func explode_and_exit():
	var explosion = explosion_scene.instantiate()
	explosion.position = global_position
	GameStateManager.main_scene.add_child.call_deferred(explosion)
	queue_free()

func _on_magnetic_influence_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		if area.position.x > position.x:
			area.velocity.x += influence_x * 0.5
		else:
			area.velocity.x -= influence_x * 0.5
		if area.position.y > position.y:
			area.velocity.y += influence_y * 0.5
		else:
			area.velocity.y -= influence_y * 0.5

func _on_magnetic_influence_body_entered(body: Node3D) -> void:
	if body is Ball:
		if body.position.x > position.x:
			body.linear_velocity.x += influence_x
		else:
			body.linear_velocity.x -= influence_x
		if body.position.y > position.y:
			body.linear_velocity.y += influence_y
		else:
			body.linear_velocity.y -= influence_y
