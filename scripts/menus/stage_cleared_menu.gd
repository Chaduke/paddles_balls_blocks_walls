# stage_cleared_menu.gd
extends Control

func _ready():
	$stage_cleared_label.text = "Stage " + str(Global.current_stage) + " cleared!"
	platform_specific_inits()	

func platform_specific_inits():
	if OS.get_name()=="Web":
		$quit_button.hide()

func update_labels():
	# check if stage time beats the record	
	var best_stage_time = Global.stage_times_dict[Global.current_stage]
	$old_best_stage_time_label.text = "Old Best Stage Time " + Global.format_time(best_stage_time)
	if Global.stage_time < best_stage_time:
		$stage_time_congrats_label.text = "You beat your best -Stage Time- for Stage " + str(Global.current_stage)
		$new_best_stage_time_label.text = "New Best Stage Time " + Global.format_time(Global.stage_time)
		# store the new stage time record 
		Global.stage_times_dict[Global.current_stage] = Global.stage_time
		Global.save_times()
	else:
		$stage_time_congrats_label.hide()
		$old_best_stage_time_label.hide()
		$new_best_stage_time_label.hide()
	
	var best_total_time = Global.total_times_dict[Global.current_stage]
	$old_best_total_time_label.text = "Old Best Total Time " + Global.format_time(best_total_time)
	if Global.accumlated_time < best_total_time:
		$total_time_congrats_label.text = "You beat your best -Total Time- for Stage " + str(Global.current_stage)
		$new_best_total_time_label.text = "New Best Total Time " + Global.format_time(Global.accumlated_time)
		# store the new total time record
		Global.total_times_dict[Global.current_stage] = Global.accumlated_time
		Global.save_times()
	else:
		$total_time_congrats_label.hide()
		$old_best_total_time_label.hide()
		$new_best_total_time_label.hide()
	
func _on_next_stage_button_pressed():
	hide()
	var main_scene = get_tree().root.get_child(2)
	var stage_scene = main_scene.find_child("stage")
	stage_scene.load_next_stage()

func _on_quit_button_pressed():
	var main_scene = get_tree().root.get_child(2)
	var confirm = main_scene.find_child("confirm_quit_menu")
	confirm.show()
	confirm.previous_menu = self
	hide()
