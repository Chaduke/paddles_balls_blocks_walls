extends Control
var current_index = 1
var times_dict = {}

func _ready():
	load_data()
	$status_label.text = "Ready..."

func update_labels():
	$stage_label.text = "Stage " + str(current_index)
	$time_label.text = "Time " + Global.format_time(times_dict[current_index])
	$status_label.text = "Showing Stage Record Time " + str(current_index) + " of 100." 
	
func _process(_delta):	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_left"):
		current_index -=1
		if current_index < 1 : current_index = 100
		update_labels()
	if Input.is_action_just_pressed("ui_right"):
		current_index +=1
		if current_index > 100: current_index = 1
		update_labels()
		
func save_data():
	var save_file = FileAccess.open("user://stage_times.json", FileAccess.WRITE)
	var times_string = JSON.stringify(times_dict)
	save_file.store_line(times_string)
	
func load_data():
	var load_file = FileAccess.open("user://stage_times.json", FileAccess.READ)
	var times_string = load_file.get_as_text()
	var temp_dict = JSON.parse_string(times_string)
	times_dict.clear() 
	for key in temp_dict.keys(): 
		var int_key = int(key) 
		times_dict[int_key] = temp_dict[key]
		
	$status_label.text = "Times read from disk."
	current_index = 1
	update_labels()
	
func reset_times():
	for i in range (1,101):
		#times_dict[i] = randf_range(30.0,300.0)
		times_dict[i] = 600
	save_data()
	$status_label.text = "Times reset and saved."
	current_index = 1
	update_labels()

func _on_reset_times_pressed():
	reset_times()

func _on_load_data_button_pressed():
	load_data()
