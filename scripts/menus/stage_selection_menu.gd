extends Control

const STAGES_PER_PAGE = 10  # 2 rows of 5 buttons
var current_page = 0
var elapsed_time = 0.0

func _ready():
	update_stage_buttons()	
	#create_thumbnails()
	
func _process(delta):
	elapsed_time+=delta
	if visible and Input.is_action_just_pressed("select_stage") and elapsed_time > 0.1:
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Global.get_main().elapsed_time = 0.0
		get_tree().paused = false

func update_stage_buttons():
	for i in range(10):
		var stage_button = $GridContainer.get_child(i)
		stage_button.hide()
			
	var start_stage = current_page * STAGES_PER_PAGE
	var end_stage = min(start_stage + STAGES_PER_PAGE, Global.total_stages)

	for stage_number in range(start_stage, end_stage):
		var stage_button = $GridContainer.get_child(stage_number - start_stage)
		stage_button.get_node("Label").text = "Stage " + str(stage_number)
		stage_button.stage_number = stage_number
		if stage_button.get_node("TextureButton").pressed.is_connected(_on_texture_button_pressed):
			stage_button.get_node("TextureButton").pressed.disconnect(_on_texture_button_pressed)
		stage_button.get_node("TextureButton").pressed.connect(_on_texture_button_pressed.bind(stage_number))
		stage_button.show()
	
func _on_texture_button_pressed(stage_number):
	Global.current_stage = stage_number
	# print("Current stage set to: ", Global.current_stage)
	get_tree().paused = false
	get_tree().reload_current_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_next_page_pressed():
	current_page += 1
	if current_page > int(Global.total_stages/10.0) : current_page = int(Global.total_stages/10.0)
	update_stage_buttons()

func _on_previous_page_pressed():
	current_page -= 1
	if current_page < 0: current_page = int(Global.total_stages/10.0)
	update_stage_buttons()
