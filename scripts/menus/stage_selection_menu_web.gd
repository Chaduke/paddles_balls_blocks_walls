# stage_selection_menu_web.gd
extends Control

var current_page = 0
var elapsed_time = 0.0
var current_button = 0

func _ready():
	update_pages()
	
func _input(event):
	if visible:
		if event is InputEventMouseMotion:
			$mouse_location.text = "Mouse Location : " + str(event.position) + " " + str(current_button)
			mouse_moved(event.position)
		elif event is InputEventMouseButton:
			load_level()
				
func load_level():
	if current_button > 0:
		Global.current_stage = current_button
		#print("Current stage set to: ", Global.current_stage)
		get_tree().paused = false
		get_tree().reload_current_scene()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Global.stage_selected = true
		
func mouse_moved(pos):
	var top = 300
	var bottom = 500
	var left = 70
	var right = left + 334
	current_button = 0
	for i in range(10):
		if i == 5:
			top = 600
			bottom = 800
			left = 70
			right = left + 334
		else:
			if i < 5: 
				left = i * 359 + 70
				right = left + 334
			else:
				left = (i-5) * 359 + 70
				right = left + 334
		if mouse_in_rect(pos,left,top,right,bottom):
			current_button = i + 1 + current_page * 10

func mouse_in_rect(pos,l,t,r,b):
	return pos.x > l and pos.x < r and pos.y > t and pos.y < b
			
func _process(delta: float) -> void:
	elapsed_time += delta
	if visible:
		if Input.is_action_just_pressed("select_stage") and elapsed_time > 0.1:
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Global.get_main().elapsed_time = 0.0
			get_tree().paused = false
		if Input.is_action_just_pressed("ui_text_caret_left"):
			previous_page()
		if Input.is_action_just_pressed("ui_text_caret_right"):
			next_page()

func update_pages():
	var start_stage_string = str(current_page * 10 + 1)
	if current_page == 0:
		start_stage_string = "0" + start_stage_string
	var end_stage_string = str((current_page + 1) * 10)
	var group_string = "stages_" + start_stage_string + "_thru_" + end_stage_string
	#print("Group string = " + group_string)
	for child in get_children():
		if child.name.begins_with("stages"):
			if child.name == group_string:
				child.visible = true
			else:
				child.visible = false

func next_page():
	var last_page = int((Global.total_stages - 1)/10.0) - 1
	current_page += 1
	if current_page > last_page : current_page = 0
	update_pages()
		
func _on_next_page_pressed():
	next_page()	
	
func _on_previous_page_pressed():
	previous_page()
	
func previous_page():
	var last_page = int((Global.total_stages - 1)/10.0) - 1
	current_page -= 1
	if current_page < 0: current_page = last_page
	update_pages()
