# pickup_item.gd
class_name PickupItem extends Area3D
@export var item_type: String = "Random"

# the default pickup item timer is just 1
# others will be changed based on what they are
# like infinite balls is 20 or 30
@export var timer = 1
# we use elapsed_time to count up to the timer value
# we could also create timer nodes
var elapsed_time = 0.0

# states to track movement of the pickup item
var state
enum {MOVING_UP,MOVING_DOWN,MOVING_RIGHT,COMPLETE}

# we use start_position to move the item "up" from the block
# its a just an extra little "for show" animation
var start_position

# slots for the pickup items to rest in on the right side 
# while their timer counts down and their effects are enabled
# slots 1-4 are defined in Global.gd 
# so they can be accessed outside this instance
var slot = 0

# this is the slot location on the right gutter
# this gets assigned once the item is caught by the paddle
# and an open slot is found for the item
# at this point the item state will be 2 (moving right)
var target_position = Vector3(0,0,0)

var grower_sound = preload("res://assets/wave/grower.wav")
var shrinker_sound = preload("res://assets/wave/shrinker.wav")
var max_paddle_sound = preload("res://assets/wave/max_paddle.wav")
var infinite_balls_sound = preload("res://assets/wave/infinite_balls.wav")
var large_balls_sound = preload("res://assets/wave/large_balls.wav")
var small_balls_sound = preload("res://assets/wave/small_balls.wav")
var gravity_reverse_sound = preload("res://assets/wave/gravity_reverse.wav")
var paddle_collision = false

func _ready():
	state = MOVING_UP
	start_position = position
	show_item()
		
func show_item():
	if item_type == "Random":
		pick_random()
	if item_type == "Grower":
		$Grower.show()
	elif item_type == "Shrinker":
		$Shrinker.show()
	elif item_type == "SmallBalls":
		$Smallballs.show()
	elif item_type == "LargeBalls":
		$Largeballs.show()
	elif item_type == "GravityReverse":
		$GravityReverse.show()
		timer = 10
	elif item_type == "InfiniteBalls":
		$InfiniteBalls.show()
		timer = 20
	elif item_type == "MaxPaddle":
		$MaxPaddle.show()
		timer = 20
		
func pick_random():
	var rng = RandomNumberGenerator.new() 
	rng.randomize() # Ensure randomness by randomizing the seed 
	var random_int = rng.randi_range(0, 6)
	if random_int == 0:
		item_type = "Grower"
	elif random_int == 1:
		item_type = "Shrinker"
	elif random_int == 2:
		item_type = "LargeBalls"
	elif random_int == 3:
		item_type = "SmallBalls"
	elif random_int == 4:
		item_type = "GravityReverse"
	elif random_int == 5:
		item_type = "InfiniteBalls"
	elif random_int == 6:
		item_type = "MaxPaddle"
		
func _process(delta):
		if state == MOVING_UP:
			move_up()
		elif state == MOVING_DOWN:
			move_down()
		elif state == MOVING_RIGHT:
			move_right()
		else:
			elapsed_time+=delta
			update_timed_item()

func move_up():	
	if position.y < start_position.y + 2:
		position.y += 0.1
	else:
		state = MOVING_DOWN
		
func move_down():
	position.y -= 0.1
	rotation.x+=0.1
	if position.y < 0:
		queue_free()
	else:
		if paddle_collision:
			# check for empty slot and set target location
			if set_target_position():
				enable_item_effect()
			else:
				queue_free()

func enable_item_effect():
	var paddle=GameStateManager.main_scene.get_node("paddle")
	if item_type == "Grower":
		$AudioStreamPlayer.stream = grower_sound
		$AudioStreamPlayer.play()
		paddle.grow_paddle()
	elif item_type == "Shrinker":
		$AudioStreamPlayer.stream = shrinker_sound
		$AudioStreamPlayer.play()
		paddle.shrink_paddle()
	elif item_type == "LargeBalls":
		$AudioStreamPlayer.stream = large_balls_sound
		$AudioStreamPlayer.play()
		grow_balls()
	elif item_type == "SmallBalls":
		$AudioStreamPlayer.stream = small_balls_sound
		$AudioStreamPlayer.play()
		shrink_balls()
	elif item_type == "GravityReverse":
		$AudioStreamPlayer.stream = gravity_reverse_sound
		$AudioStreamPlayer.play()
		reverse_gravity()
	elif item_type == "InfiniteBalls":
		Global.infinite_balls = true
		$AudioStreamPlayer.stream = infinite_balls_sound
		$AudioStreamPlayer.play()
	elif item_type == "MaxPaddle":
		$AudioStreamPlayer.stream = max_paddle_sound
		$AudioStreamPlayer.play()
		paddle.maximize()
		
func reverse_gravity():
	Global.gravity_reversed = true
	# change the Y vector to 1 instead of -1, reversing gravity pull
	PhysicsServer3D.area_set_param(get_world_3d().space, 
	PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, 
	Vector3(0, 1, 0))
	GameStateManager.main_scene.get_node("ball_controller").reverse_gravity()
			
func restore_gravity():
	Global.gravity_reversed = false
	PhysicsServer3D.area_set_param(get_world_3d().space, 
	PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, 
	Vector3(0, -1, 0))
	GameStateManager.main_scene.get_node("ball_controller").restore_gravity()
				
func grow_balls():
	var current = Global.current_ball_size
	if current < 4:
		Global.current_ball_size *=2
		GameStateManager.main_scene.get_node("ball_controller").update_ball_size()

func shrink_balls():
	var current = Global.current_ball_size
	if current > 1:
		@warning_ignore("integer_division")
		Global.current_ball_size = int(Global.current_ball_size/2)
		# print("Current ball size shrunk to " + str(Global.current_ball_size))		
		GameStateManager.main_scene.get_node("ball_controller").update_ball_size()
		
func move_right():
	# Current position 
	var current_position = global_transform.origin
	if current_position.distance_to(target_position) > 0.01:
		# Interpolate towards target position 
		var new_position = current_position.lerp(target_position, 0.1) 
		global_transform.origin = new_position
	else: 
		state = COMPLETE
		$pickup_timer.visible = true
		rotation.x = 0

func update_timed_item():
	var secs = int(elapsed_time) % 60
	$pickup_timer.text = str(timer - secs)
	if secs == timer:
		Global.set_slot_inactive(slot)
		if item_type == "GravityReverse":
			restore_gravity()
		elif item_type == "InfiniteBalls":
			Global.infinite_balls = false
		elif item_type == "MaxPaddle":
			GameStateManager.main_scene.get_node("paddle").normalize()
		queue_free()

func check_existing_items():
	# make sure it is in the list of item types we want to "time increment"
	if item_type in ["InfiniteBalls","GravityReverse","MaxPaddle"]:	
		for child in GameStateManager.main_scene.get_children():
			# make sure it's not us, but is this class
			if child != self and child is PickupItem:
				# make sure the item types match
				# and that the item is already caught by the paddle
				# states 0 and 1 are prior to it hitting the paddle
				if child.item_type == item_type and child.state > 1:
					child.timer += timer
					return true
	return false
	
func set_target_position():
	# check to see if we already have an existing item in a slot
	# and if we should just add to it's timer rather than adding a new item
	if check_existing_items():
		return false
	slot = Global.find_free_slot()
	if slot > 0:
		state = MOVING_RIGHT
		$CollisionShape3D.disabled = true
		if slot == 1:
			target_position = Vector3(15,10,-37)
		elif slot == 2:
			target_position = Vector3(18,10,-37)
		elif slot == 3:
			target_position = Vector3(15,8,-37)
		elif slot == 4:
			target_position = Vector3(18,8,-37)
		elif slot == 5:
			target_position = Vector3(15,6,-37)
		elif slot == 6:
			target_position = Vector3(18,6,-37)
		return true
	else:
		return false

func _on_body_entered(body: Node3D) -> void:
	if body is Paddle:
		paddle_collision = true
