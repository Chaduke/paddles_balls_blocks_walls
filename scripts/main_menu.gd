extends Control

func _ready():
	if not Global.game_started:	
		$start_button.show()	
		$start_button.grab_focus()
	else:
		$resume_button.show()	
		$resume_button.grab_focus()	
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Global.game_started:
			resume_game()
		else:
			get_tree().quit()
			
func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	start_game()	

func start_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$start_button.hide()
	$resume_button.show()
	hide()	
	get_tree().paused = false
	Global.game_started = true

func _on_resume_button_pressed():
	resume_game()
				
func resume_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	get_tree().paused = false

func _on_settings_button_pressed():
	hide()
	var main_scene = get_tree().root.get_child(1)
	main_scene.get_node("settings_menu").show()
