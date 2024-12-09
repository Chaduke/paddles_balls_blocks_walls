extends Control

const STAGES_PER_PAGE = 10  # 2 rows of 5 buttons
var current_page = 0
var elapsed_time = 0.0

func _ready():
	# update_stage_buttons()
	pass 
	
func _process(delta):
	elapsed_time+=delta
	if visible and Input.is_action_just_pressed("select_stage") and elapsed_time > 0.1:
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Global.get_main().elapsed_time = 0.0
		get_tree().paused = false

func update_stage_buttons():
	$GridContainer.clear_children()  # Clear existing buttons

	var start_stage = current_page * STAGES_PER_PAGE
	var end_stage = min(start_stage + STAGES_PER_PAGE, Global.total_stages)

	for stage_number in range(start_stage, end_stage):
		var stage_button = preload("res://scenes/menus/stage_button.tscn").instantiate()
		stage_button.get_node("Label").text = "Stage " + str(stage_number)
		stage_button.stage_number = stage_number
		stage_button.get_node("TextureButton").pressed.connect(_on_stage_button_pressed.bind(stage_number))
		$GridContainer.add_child(stage_button)

func _on_stage_button_pressed(stage_number):
	Global.current_stage = stage_number
	print("Current stage set to: ", Global.current_stage)
	get_tree().reload_current_scene()

func _on_next_page_pressed():
	current_page += 1
	update_stage_buttons()

func _on_previous_page_pressed():
	current_page -= 1
	update_stage_buttons()
