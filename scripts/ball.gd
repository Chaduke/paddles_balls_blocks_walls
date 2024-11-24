extends RigidBody3D
@onready var bounce = $bounce
@onready var block = $block
@onready var wall = $wall

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_exited(body):
	# print("Exited " + body.name)	
	if body.name=="paddle":
		var diff = position.x - body.position.x
		linear_velocity.y *= 1.1
		linear_velocity.x += diff * 2
		bounce.play()
	elif body.name.begins_with("block"):
		block.play()
		body.queue_free()
		linear_velocity.y*=1.1
	else: 
		wall.play()	
		linear_velocity*=1.1
