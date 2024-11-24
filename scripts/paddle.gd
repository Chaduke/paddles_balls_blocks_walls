extends CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("Hello from paddle!")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("swing_paddle"):
		if position.y > 0.5:
			position.y -= 0.3
			if position.y < 0.5:
				position.y = 0.5
	else:
		if position.y < 2.5:
			position.y +=0.3
			if position.y > 2.5:
				position.y = 2.5
var new_position
func _input(event):
	if event is InputEventMouseMotion:
		new_position = position.x + event.relative.x * 0.02
		if new_position < -14.5: new_position =-14.5
		if new_position > 8: new_position = 8
		position.x = new_position
	
