extends Control

const STAGES_PER_PAGE = 10  # 2 rows of 5 buttons
var current_page = 0
var elapsed_time = 0.0
var thumbnails = []

func _ready():
	load_thumbnails()
	update_stage_buttons()

func load_thumbnails_old():
	for stage in range(Global.total_stages):
		var image_path = "res://assets/images/thumbnails/stage" + str(stage) + ".png"
		var image = Image.new()
		image.load(image_path)
		var texture = ImageTexture.create_from_image(image)
		thumbnails.append(texture)
		
func load_thumbnails():
	thumbnails.clear()
	var dir = DirAccess.get_files_at("res://assets/images/thumbnails/")
	for file in dir:
		if file.ends_with("png"):
			var new_texture = ResourceLoader.load("res://assets/images/thumbnails/" + file)
			# Check if the loaded file is indeed a texture
			if new_texture is Texture2D:
				# Now we can add them for the array
				thumbnails.append(new_texture)
		
func _process(delta):
	elapsed_time+=delta
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

func update_stage_buttons():
	for i in range(10):
		var stage_button = $GridContainer.get_child(i)
		stage_button.hide()
			
	var start_stage = current_page * STAGES_PER_PAGE + 1
	var end_stage = min(start_stage + STAGES_PER_PAGE, Global.total_stages)

	for stage_number in range(start_stage, end_stage):
		var stage_button = $GridContainer.get_child(stage_number - start_stage)
		stage_button.get_node("Label").text = "Stage " + str(stage_number)
		if stage_button.get_node("TextureButton").pressed.is_connected(_on_texture_button_pressed):
			stage_button.get_node("TextureButton").pressed.disconnect(_on_texture_button_pressed)
		stage_button.get_node("TextureButton").pressed.connect(_on_texture_button_pressed.bind(stage_number))
		stage_button.get_node("TextureButton").texture_normal = thumbnails[stage_number-1]
		stage_button.show()
	
func _on_texture_button_pressed(stage_number):
	Global.current_stage = stage_number
	# print("Current stage set to: ", Global.current_stage)
	get_tree().paused = false
	get_tree().reload_current_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.stage_selected = true

func next_page():
	current_page += 1
	if current_page > int(Global.total_stages/10.0) : current_page = 0
	update_stage_buttons()
		
func _on_next_page_pressed():
	next_page()

func _on_previous_page_pressed():
	previous_page()	

func previous_page():
	current_page -= 1
	if current_page < 0: current_page = int(Global.total_stages/10.0)
	update_stage_buttons()	
