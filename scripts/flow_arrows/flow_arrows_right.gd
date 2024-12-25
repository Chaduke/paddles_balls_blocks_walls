# flow_arrows_right.gd
extends Area3D
class_name FlowArrowsRight

@export var lateral_force = 5
@export var vertical_damping = 0.93

var current_body = null
var current_area = null

func _physics_process(_delta):
	if current_body:
		current_body.linear_velocity.y *= vertical_damping
		current_body.apply_central_force(Vector3(lateral_force, 0, 0))
	if current_area:
		current_area.velocity.y *= vertical_damping
		current_area.velocity.x += lateral_force * 0.1
	
func _on_body_entered(body):
	if body is Ball:
		if not current_body:
			current_body = body
			current_body.global_transform.origin.y = global_transform.origin.y
		
func _on_body_exited(body):
	if body == current_body:
		current_body = null

func _on_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		current_area = area
		var diff = area.position - global_position
		if diff.x > 0:
			# entered from right
			area.velocity.x = abs(area.velocity.x) * 0.5
			#print("Area entered from " + str(diff))
			
func _on_area_exited(area: Area3D) -> void:
	if area == current_area:
		current_area = null
