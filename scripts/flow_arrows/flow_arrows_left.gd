# flow_arrows_left.gd
extends Area3D
class_name FlowArrowsLeft

@export var lateral_force = 5
@export var vertical_damping = 0.93

var current_body = null

func _physics_process(_delta):
	if current_body:
		if current_body is Ball:			
			current_body.linear_velocity.y *= vertical_damping
			current_body.apply_central_force(Vector3(-lateral_force, 0, 0))	
	
func _on_body_entered(body):	
	if not current_body:
		current_body = body	
		current_body.global_transform.origin.y = global_transform.origin.y
		
func _on_body_exited(body):
	if body == current_body:
		current_body = null
	
func report(body,event_string):
	if body is Ball:
		print("Ball " + body.name + event_string)
	else:
		print("Body " + body.name + event_string)
