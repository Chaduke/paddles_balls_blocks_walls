# flow_arrows_up.gd
extends Area3D
class_name FlowArrowsUp

@export var upward_impulse_amount = 1
@export var upward_force_amount = 0.1

var current_body = null
var current_area = null

func _physics_process(_delta):
	if current_body:
		current_body.apply_central_force(Vector3(0,upward_force_amount,0))
	if current_area:
		current_area.velocity.y += upward_force_amount
	
func _on_body_entered(body):
	#report(body," entered my area.")
	if body is Ball: 
		current_body = body
		var entry_direction = body.global_transform.origin - global_transform.origin 
		# Check the entry direction to apply force accordingly 
		if entry_direction.y > 0: 
			# Entered from the top 
			# add an impulse that is opposite its linear_velocity.y
			var yv = body.linear_velocity.y
			body.apply_central_impulse(Vector3(0, -yv, 0))
		else: 
			# Entered from the bottom 
			body.apply_central_impulse(Vector3(0, upward_impulse_amount, 0))
		#print("RigidBody3D entered from direction: ", entry_direction)	

func _on_body_exited(body):	
	if body == current_body:
		current_body = null
	
func report(body,event_string):
	if body is Ball:
		print("Ball " + body.name + event_string)
	else:
		print("Body " + body.name + event_string)

func _on_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		current_area = area
		var entry_direction = area.global_transform.origin - global_transform.origin 
		# Check the entry direction to apply force accordingly 
		if entry_direction.y > 0: 
			# Entered from the top 
			# make it bounce up sinc ethe arrows are pointing up	
			area.velocity.y = -area.velocity.y
		else: 
			# Entered from the bottom 
			# give it an upward velocity boost
			area.velocity.y += upward_impulse_amount

func _on_area_exited(area: Area3D) -> void:
	if area == current_area:
		current_area = null
