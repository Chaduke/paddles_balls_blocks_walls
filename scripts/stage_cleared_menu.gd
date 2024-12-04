# stage_cleared_menu
extends Control

func _ready():
	$stage_cleared_label.text = "Stage " + str(Global.current_stage) + " cleared!"
	platform_specific_inits()

func platform_specific_inits():
	if OS.get_name()=="Web":
		$quit_button.hide()	
		
func _on_next_stage_button_pressed():	
	hide()
	var main_scene = get_tree().root.get_child(1)
	var stage_scene = main_scene.find_child("stage")
	stage_scene.load_next_stage()

func _on_quit_button_pressed():
	get_tree().quit()
