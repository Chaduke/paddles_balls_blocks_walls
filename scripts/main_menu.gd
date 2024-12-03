extends Control

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	get_tree().paused = false	
	if not Global.game_started:
		Global.game_started = true		
		$start_button.text = "RESUME GAME"

func _on_settings_button_pressed():
	hide()
	var main_scene = get_tree().root.get_child(1)
	main_scene.get_node("settings_menu").show()
