extends CharacterBody3D
@export var item_type: String = "Random"
@onready var collision_shape_3d = $CollisionShape3D
@onready var pickup_timer = $pickup_timer
@onready var grower = $Grower
@onready var shrinker = $Shrinker
@onready var smallballs = $Smallballs
@onready var largeballs = $Largeballs
@onready var gravity_reverse = $GravityReverse

var state
var start_position
var elapsed_time = 0.0
var timer = 1
var slot = 0

var target_position = Vector3(0,0,0)

func _ready():
	state = 0
	start_position = position
	if item_type == "Random":
		pick_random()
	if item_type == "Grower":
		grower.visible = true
	elif item_type == "Shrinker":
		shrinker.visible = true
	elif item_type == "Smallballs":
		smallballs.visible = true 
	elif item_type == "Largeballs":
		largeballs.visible = true
	elif item_type == "GravityReverse":
		gravity_reverse.visible = true
		timer = 10
		
func _process(delta):
	if state == 0:
		move_up()
	elif state == 1:
		move_down()
	elif state == 2:
		move_right()
	else:
		elapsed_time+=delta
		var secs = int(elapsed_time) % 60
		pickup_timer.text = str(timer - secs)
		if secs == timer:
			Global.set_slot_inactive(slot)
			if item_type == "GravityReverse":
				PhysicsServer3D.area_set_param(get_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, Vector3(0, -1, 0))
			queue_free()

func move_up():	
	if position.y < start_position.y + 2:
		position.y += 0.1
	else:
		state = 1
		
func move_down():
	if position.y > 0:
		var collision = move_and_collide(Vector3(0,-0.1,0))		
		rotation.x+=0.1
		if collision:
			# set the target position based on how many are active
			slot = Global.find_free_slot()
			if slot > 0:
				state = 2
				collision_shape_3d.disabled = true
				if slot == 1:
					target_position = Vector3(15,15,-37)
				elif slot == 2:
					target_position = Vector3(18,15,-37)
				elif slot == 3:
					target_position = Vector3(15,13,-37)
				elif slot == 4:
					target_position = Vector3(18,13,-37)
				var paddle=get_tree().root.get_child(1).get_node("paddle")
				var main_scene = get_tree().root.get_child(1)
				if item_type == "Grower":
					# change the paddle size if possible					
					paddle.grow_paddle()					
				elif item_type == "Shrinker":
					paddle.shrink_paddle()
				elif item_type == "Largeballs":					
					if Global.current_ball_size == 1:
						Global.current_ball_size = 2
						main_scene.update_ball_size()
					elif Global.current_ball_size == 2:
						Global.current_ball_size = 4
						main_scene.update_ball_size()
					elif Global.current_ball_size == 4:
						Global.current_ball_size = 8
						main_scene.update_ball_size()
				elif item_type == "Smallballs":
					if Global.current_ball_size == 8:
						Global.current_ball_size = 4
						main_scene.update_ball_size()
					elif Global.current_ball_size == 4:
						Global.current_ball_size = 2
						main_scene.update_ball_size()
					elif Global.current_ball_size == 2:
						Global.current_ball_size = 1
						main_scene.update_ball_size()
				elif item_type == "GravityReverse":					
					PhysicsServer3D.area_set_param(get_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, Vector3(0, 1, 0))
			else:
				queue_free()
	else:
		queue_free()
		
func move_right():
	# Current position 
	var current_position = global_transform.origin
	if current_position.distance_to(target_position) > 0.01:
		# Interpolate towards target position 
		var new_position = current_position.lerp(target_position, 0.1) 
		global_transform.origin = new_position
	else: 
		state = 3
		pickup_timer.visible = true
		rotation.x = 0

func pick_random():
	var rng = RandomNumberGenerator.new() 
	rng.randomize() # Ensure randomness by randomizing the seed 
	var random_int = rng.randi_range(0, 4)
	if random_int == 0:
		item_type = "Grower"
	elif random_int == 1:
		item_type = "Shrinker"
	elif random_int == 2:
		item_type = "Largeballs"
	elif random_int == 3:
		item_type = "Smallballs"
	elif random_int == 4:
		item_type = "GravityReverse"
