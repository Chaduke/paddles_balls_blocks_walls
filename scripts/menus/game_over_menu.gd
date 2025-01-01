# game_over_menu.gd
extends Control

func _ready():
	platform_specific_inits()
	
func platform_specific_inits():
	if OS.get_name()=="Web":
		$quit_button.hide()
	
func _on_restart_button_pressed():
	hide()
	GameStateManager.main_scene.restart_stage()

func _on_quit_button_pressed():	
	var confirm = GameStateManager.main_scene.find_child("confirm_quit_menu")
	confirm.show()
	confirm.previous_menu = self
	hide()
	
