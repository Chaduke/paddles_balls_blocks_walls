extends RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_exited(body):
	# print("Exited " + body.name)
	if body.name=="paddle":
		linear_velocity+=Vector3((randf()-0.5) * 5,5,0)
	if body.name.begins_with("block"):
		body.queue_free()
