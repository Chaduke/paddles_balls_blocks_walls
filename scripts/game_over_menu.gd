# game_over_menu.gd
extends Control

func _on_restart_button_pressed():
	hide()
	var main_scene = get_tree().root.get_child(1)
	main_scene.restart_stage()

func _on_quit_button_pressed():
	get_tree().quit()
