extends Area3D
class_name MovingBlock

@export var velocity = Vector3(0,0,0)
@export var acceleration = Vector3(0,0,0)

func _process(delta: float) -> void:
	velocity+=acceleration * delta
	position+=velocity * delta
	if position.x > 29.5:
		position.x = 1.5
	elif position.x < 1.5:
		position.x = 29.5

func _on_area_entered(area: Area3D) -> void:
	if area is BallClassic:
		queue_free()
