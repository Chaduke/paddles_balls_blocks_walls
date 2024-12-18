# main_menu.gd
extends Control
var elapsed_time = 0.0

func _process(delta):
	elapsed_time += delta
	if Input.is_action_just_pressed("ui_cancel"):
		if Global.game_started:
			if elapsed_time > 0.1 and other_menus_closed(): 
				resume_game()
		else:
			if elapsed_time > 0.1: get_tree().quit()

func other_menus_closed():
	var main_scene = get_tree().root.get_child(2)
	var game_over_menu = main_scene.find_child("game_over_menu")
	var stage = main_scene.find_child("stage")
	var stage_cleared_menu = stage.find_child("stage_cleared_menu")
	var all_stages_cleared_menu = stage.find_child("all_stages_cleared_menu")
	if game_over_menu.visible or \
	stage_cleared_menu.visible or \
	all_stages_cleared_menu.visible:
		return false
	else:
		return true

func _ready():
	$version_label.text = "Version " +  ProjectSettings.get_setting("application/config/version")
	$platform_label.text = "Platform " + OS.get_name()
	platform_specific_inits()
	if not Global.game_started:
		$start_button.show()
		if OS.get_name()=="Web":
			$start_audio_button.show()
		else:
			MusicServer.play_game_intro()
	else:
		$resume_button.show()
		
func platform_specific_inits():
	if OS.get_name()=="Web":
		$quit_button.hide()

func _on_quit_button_pressed():
	var main_scene = get_tree().root.get_child(2)
	var confirm = main_scene.find_child("confirm_quit_menu")
	confirm.show()
	confirm.previous_menu = self
	hide()

func _on_start_button_pressed():
	start_game()

func start_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$start_button.hide()
	$resume_button.show()
	hide()	
	get_tree().paused = false
	Global.game_started = true
	Global.stage_selected = false
	#OS.window_fullscreen = true

func _on_resume_button_pressed():
	resume_game()
				
func resume_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	get_tree().paused = false
	var main_scene = get_tree().root.get_child(2)
	main_scene.elapsed_time = 0.0	

func _on_settings_button_pressed():
	hide()
	var main_scene = get_tree().root.get_child(2)
	main_scene.get_node("settings_menu").show()

func _on_start_button_mouse_entered() -> void:
	if $start_button.visible:
		$button_enter.play()

func _on_resume_button_mouse_entered() -> void:
	if $resume_button.visible:
		$button_enter.play()

func _on_settings_button_mouse_entered() -> void:
	$button_enter.play()

func _on_quit_button_mouse_entered() -> void:
	$button_enter.play()

func _on_start_audio_button_pressed() -> void:
	MusicServer.play_game_intro()
