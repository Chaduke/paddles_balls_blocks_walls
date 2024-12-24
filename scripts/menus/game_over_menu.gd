# game_over_menu.gd
extends Control

func _ready():
	platform_specific_inits()
	
func platform_specific_inits():
	if OS.get_name()=="Web":
		$quit_button.hide()
	
func _on_restart_button_pressed():
	hide()
	Global.get_main().restart_stage()

func _on_quit_button_pressed():	
	var confirm = Global.get_main().find_child("confirm_quit_menu")
	confirm.show()
	confirm.previous_menu = self
	hide()
	
