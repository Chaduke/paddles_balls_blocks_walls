# all_stages_clear_menu.gd
extends Control

func _ready():
	pass 

func _on_restart_button_pressed():
	Global.current_stage = 1
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()
