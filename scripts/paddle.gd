# paddle.gd
class_name Paddle extends CharacterBody3D
@onready var mesh_instance_3d = $MeshInstance3D

@export var paddle_models = { 
	4: preload("res://assets/models/paddle_4m.glb"),
	8: preload("res://assets/models/paddle_8m.glb"), 
	12: preload("res://assets/models/paddle_12m.glb"), 
	16: preload("res://assets/models/paddle_16m.glb"), 
	20: preload("res://assets/models/paddle_20m.glb"), 
	24: preload("res://assets/models/paddle_24m.glb"), 
	28: preload("res://assets/models/paddle_28m.glb") 
	}

var current_size = 8
var left_bounds 
var right_bounds
@onready var collision_shape_3d = $CollisionShape3D

# to detect if we should give the "classic" ball a boost
var upswing = false

func _ready():
	update_paddle_model(current_size)
	
func update_paddle_model(size):
	if paddle_models.has(size):
		if mesh_instance_3d:
			mesh_instance_3d.queue_free()
		mesh_instance_3d = paddle_models[size].instantiate()
		add_child(mesh_instance_3d)
		mesh_instance_3d.name="MeshInstance3D"
		collision_shape_3d.shape.extents.x = size / 2.0
		collision_shape_3d.shape.extents.y = 0.5
		collision_shape_3d.shape.extents.z = 0.5
		@warning_ignore("integer_division")
		left_bounds = -18.5 + current_size / 2
		@warning_ignore("integer_division")
		right_bounds = 12 - current_size / 2
		set_paddle_position(position.x)
		
func grow_paddle(): 
	if current_size < 28: 
		current_size += 4 
		update_paddle_model(current_size)
		
func shrink_paddle(): 
	if current_size > 4: 
		current_size -= 4 
		update_paddle_model(current_size)

func maximize():
	current_size = 28
	update_paddle_model(current_size)

func normalize():
	current_size = 8
	update_paddle_model(current_size)

func _process(_delta):	
	if Input.is_action_pressed("swing_paddle"):
		if OS.get_name() == "Web": Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if position.y > 0.5:
			position.y -= 0.3
			if position.y < 0.5:
				position.y = 0.5
	else:
		if position.y < 2.5:
			position.y +=0.3
			upswing = true
			if position.y > 2.5:
				position.y = 2.5
		else:
			upswing = false

func _input(event):
	if event is InputEventMouseMotion:
		var new_position = position.x + event.relative.x * 0.02
		set_paddle_position(new_position)
		
func set_paddle_position(p):
	var px = p
	if p < left_bounds: px = left_bounds
	if p > right_bounds : px = right_bounds
	position.x = px
