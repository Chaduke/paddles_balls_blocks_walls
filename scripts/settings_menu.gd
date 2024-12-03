# settings_menu.gd
extends Control

func _process(_delta):
	if visible and Input.is_action_just_pressed("ui_cancel"):	
		back_to_main()

func _on_back_button_pressed():
	back_to_main()
	
func back_to_main():
	hide()
	var main_scene = get_tree().root.get_child(1)
	main_scene.get_node("main_menu").show()
	
func _on_show_background_checkbutton_toggled(toggled_on):
	var main_scene = get_tree().root.get_child(1)
	var stage = main_scene.get_node("stage")
	var background_3d = stage.get_node("background_3d")
	if toggled_on:
		background_3d.show()
		Global.show_background_3d = true 
	else:
		background_3d.hide()
		Global.show_background_3d = false
