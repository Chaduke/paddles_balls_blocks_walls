# main.gd
extends Node3D

var game_ready = false
var camera_ready = false
var elapsed_time = 0.0

func _ready():	
	set_globals()
	if not Global.game_started:
		$main_menu.show()
		get_tree().paused = true
		
func set_globals():
	# after each stage is complete 
	# I call a get_tree().reload_current_scene()
	if Global.game_mode == Global.TIMED:
		Global.balls_left = 10
		
	Global.current_ball_size = 2
	Global.infinite_balls = false
	Global.gravity_reversed = false
	Global.stage_started = false
	# set gravity to normal 
	PhysicsServer3D.area_set_param(get_world_3d().space, 
	PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, 
	Vector3(0, -1, 0))
	Global.deactivate_all_slots()
	# make sure inputs are setup properly based on platform
	os_specific_inits()

func os_specific_inits():
	# web build
	if OS.get_name() == "Web":
		var escape_event = InputEventKey.new() 
		escape_event.keycode = KEY_ESCAPE
		var tab_event = InputEventKey.new() 
		tab_event.keycode = KEY_TAB
		InputMap.action_erase_event("ui_cancel",escape_event)
		InputMap.action_add_event("ui_cancel", tab_event)
		
func _process(delta):
	elapsed_time+=delta
	if Global.game_started:
		position_camera()
		get_input()
			
func position_camera():
	# this is just an "opening movement" thing so show off the 3D scenery
	if not camera_ready:
		if $camera.position.z < 0:
			$camera.position.z += 4
		else:
			camera_ready = true
			$stage.start_rsg()
			
func set_game_ready():
	# called from stage after "ready, set, go"
	game_ready = true
	if Global.game_mode == Global.ARCADE: $ball_controller.attach_ball_to_paddle()
	
func get_input():
	if Input.is_action_just_pressed("ui_cancel"):
		if elapsed_time > 0.1 : toggle_main_menu()
		
	if Input.is_action_just_pressed("spawn_ball") and game_ready:
		if Global.game_mode==Global.TIMED:
			$ball_controller.spawn_ball()
		elif Global.game_mode==Global.ARCADE:
			if $ball_controller.remove_ball_from_paddle():
				#print("Ball removed from paddle")
				pass
			else:
				#print("No ball to remove")
				pass
			
	if Input.is_action_just_pressed("settings"):
		if elapsed_time > 0.1 : toggle_settings()
	if Input.is_action_just_pressed("reset"):
		restart_stage()
	if Input.is_action_just_pressed("ball_gun"):
		if (Global.game_mode==Global.ARCADE and Global.infinite_balls) or Global.game_mode==Global.TIMED:
			$ball_gun_timer.start()
	if Input.is_action_just_pressed("select_stage"):
		toggle_stage_selection()
	if Input.is_action_just_pressed("help_menu"):
		toggle_help_menu()

func toggle_stage_selection():
	if OS.get_name() == "Web":
		$stage_selection_menu_web.show()
		$stage_selection_menu_web.elapsed_time = 0.0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	else:
		$stage_selection_menu_web.show()
		$stage_selection_menu_web.elapsed_time = 0.0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func toggle_help_menu():
	if $help_menu.active:
		$camera.lerping = true
		$camera.target_position = Vector3(0,15,0)
		$help_menu.active = false
	else:
		$camera.lerping = true
		$camera.target_position = Vector3(0,45,0)
		$help_menu.active = true

func toggle_main_menu():
	$main_menu.show()
	$main_menu.elapsed_time = 0.0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
			
func toggle_settings():
		$settings_menu.show()
		$settings_menu.elapsed_time = 0.0
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
func game_over():
	$game_over_menu.show()
	set_globals()
	get_tree().paused = true
	Global.stage_started = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func restart_stage():
	# called from game_over_menu.gd
	$game_over_menu.hide()
	get_tree().paused = false
	if Global.game_mode == Global.ARCADE : Global.balls_left = 3
	get_tree().reload_current_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	
func _on_ball_gun_timer_timeout():
	$ball_controller.spawn_ball()
