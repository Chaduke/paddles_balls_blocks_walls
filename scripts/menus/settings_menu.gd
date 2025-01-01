# settings_menu.gd
extends Control

var elapsed_time = 0.0

func _process(delta):
	elapsed_time += delta
	if Input.is_action_just_pressed("settings"):
		if elapsed_time > 0.1: resume_game()
		
func resume_game():
	hide()
	get_tree().paused = false	
	GameStateManager.main_scene.elapsed_time = 0.0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_back_button_pressed():
	back_to_main()
	
func back_to_main():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.enable_cursor(true)
	
func _on_show_background_checkbutton_toggled(toggled_on):
	var main_scene = get_tree().root.get_child(2)
	var stage = main_scene.get_node("stage")
	var background_3d = stage.get_node("background_3d")
	if toggled_on:
		background_3d.show()
		Global.show_background_3d = true 
	else:
		background_3d.hide()
		Global.show_background_3d = false

func _on_reset_times_button_pressed():
	if $cancel_button.visible:
		Global.reset_stage_times()
		Global.reset_total_times()
		$cancel_button.hide()
		$reset_times_button.text = "Reset Record Times"
		var main_scene = get_tree().root.get_child(2)
		var stage = main_scene.find_child("stage")
		stage.set_best_time_labels()
	else:
		$cancel_button.show()
		$reset_times_button.text = "Click to Confirm"

func _on_cancel_button_pressed():
	$cancel_button.hide()
	$reset_times_button.text = "Reset Record Times"

func _on_ball_physics_checkbutton_toggled(toggled_on):
	Global.default_ball_mode = toggled_on
