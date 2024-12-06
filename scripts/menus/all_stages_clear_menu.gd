# all_stages_clear_menu.gd
extends Control

func _ready():
	platform_specific_inits()

func platform_specific_inits():
	if OS.get_name()=="Web":
		$quit_button.hide()	

func _on_restart_button_pressed():
	Global.current_stage = 1
	get_tree().paused = false
	get_tree().reload_current_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	

func _on_quit_button_pressed():
	get_tree().quit()
