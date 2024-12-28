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
		$game_mode_list.select(Global.game_mode)
		$stages_list.select(Global.stages_mode)
		$game_mode_cover_rect.hide()
		$stages_cover_rect.hide()
		update_game_mode_text()
		update_stages_mode_text()
		if OS.get_name()=="Web":
			$start_audio_button.show()
		else:
			MusicServer.play_game_intro()
	else:
		$resume_button.show()

func update_game_mode_text():
	if Global.game_mode == Global.TIMED:
		$timed_mode_label.show()
		$arcade_mode_label.hide()
	elif Global.game_mode == Global.ARCADE:
		$arcade_mode_label.show()
		$timed_mode_label.hide()
		
func update_stages_mode_text():
	if Global.stages_mode == Global.OLD:
		$old_stages_label.show()
		$new_stages_label.hide()
	elif Global.game_mode == Global.NEW:
		$new_stages_label.show()
		$old_stages_label.hide()
		
func platform_specific_inits():
	if OS.get_name()=="Web":
		$quit_button.hide()

func _on_quit_button_pressed():	
	var confirm = Global.get_main().find_child("confirm_quit_menu")
	confirm.show()
	confirm.previous_menu = self
	hide()

func _on_start_button_pressed():
	start_game()

func start_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$start_button.hide()
	$resume_button.show()
	$game_mode_cover_rect.show()
	$stages_cover_rect.show()
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
	Global.get_main().elapsed_time = 0.0

func _on_settings_button_pressed():
	hide()
	Global.get_main().get_node("settings_menu").show()

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

func _on_game_mode_list_item_selected(index: int) -> void:
	Global.game_mode = index
	update_game_mode_text()

func _on_stages_list_item_selected(index: int) -> void:
	Global.stages_mode = index
	update_stages_mode_text()
