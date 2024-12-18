# global.gd
extends Node

var current_stage = 1
# you have to count stage 0 in total_stages, 0 is the testing stage
# so total_stages is the number of playable stages + 1
var total_stages = 52
var current_ball_size = 2
var infinite_balls = false
var gravity_reversed = false

var game_started = false
var stage_started = false

# if stage is selected from the menu
# don't compute total time
var stage_selected = false

# times for current game
var stage_time = 0.0
var accumlated_time = 0.0

# settings 
var show_background_3d = false

# ball physics mode
# true = new balls will be spawned as Rigidbody3D balls as defined in ball.gd
# false = new balls spawned as Area3D balls, defined in ball_classic.gd
var default_ball_mode = false

# dictionaries to store record times
var stage_times_dict = {}
var total_times_dict = {}

var creating_thumbnails = false

# slots for item pickups 
var slot1 = false
var slot2 = false
var slot3 = false
var slot4 = false

func get_main():
	var m = get_tree().root.get_child(2)
	return m
	
func get_stage():
	return get_main().find_child("stage")
	
func ball_offset():
	return (current_ball_size / 4.0 + 0.5)
	
func load_times():
	load_time_dict(stage_times_dict,"user://stage_times.json")
	load_time_dict(total_times_dict,"user://total_times.json")
	
func save_times():
	save_time_dict(stage_times_dict,"user://stage_times.json")
	save_time_dict(total_times_dict,"user://total_times.json")

func load_time_dict(dict,file_path):
	var load_file = FileAccess.open(file_path, FileAccess.READ)
	if load_file == null:
		reset_stage_times()
		reset_total_times()
		load_file = FileAccess.open(file_path, FileAccess.READ)
		
	var times_string = load_file.get_as_text()
	load_file.close()
	var temp_dict = JSON.parse_string(times_string)
	dict.clear() 
	for key in temp_dict.keys(): 
		var int_key = int(key) 
		dict[int_key] = temp_dict[key]
		
func save_time_dict(dict,file_path):
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	var times_string = JSON.stringify(dict)
	save_file.store_line(times_string)
	save_file.close()
	
func reset_stage_times():
	for i in range (1,101):
		# default time is 10 minutes
		stage_times_dict[i] = 600
	save_time_dict(stage_times_dict,"user://stage_times.json")
	
func reset_total_times():
	for i in range (1,101):
		# add 10 minutes per stage
		total_times_dict[i] = 600 * i
	save_time_dict(total_times_dict,"user://total_times.json")

func deactivate_all_slots():
	for i in range(1,4):
		set_slot_inactive(i)

func find_free_slot():
	if not slot1:
		slot1 = true
		return 1
	elif not slot2:
		slot2 = true
		return 2
	elif not slot3:
		slot3 = true
		return 3
	elif not slot4:
		slot4 = true
		return 4
	else:
		return 0
		
func set_slot_inactive(to_inactivate):
	if to_inactivate == 1:
		slot1 = false
	elif to_inactivate == 2: 
		slot2 = false
	elif to_inactivate == 3:
		slot3 = false
	elif to_inactivate == 4: 
		slot4 = false

func format_time(time):
	# Calculate minutes, seconds, and hundredths from the time
	var mins = int(time / 60)
	var secs = int(time) % 60
	var hund = int(time * 100) % 100
	return str(mins) + "m " + str(secs) + "s " + format_hundredths(hund)

func format_hundredths(h): 
	# Format hundredths to always be two digits 
	var hundredths_str = str(h) 
	if h < 10: 
		hundredths_str = "0" + hundredths_str 
	return hundredths_str
