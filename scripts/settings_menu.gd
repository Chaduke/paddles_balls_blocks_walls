extends Control


func _process(_delta):
	if visible and Input.is_action_just_pressed("ui_cancel"):	
		hide()
		var main_scene = get_tree().root.get_child(1)
		main_scene.get_node("main_menu").show()	

func _on_show_background_checkbutton_toggled(toggled_on):
	var main_scene = get_tree().root.get_child(1)
	var stage = main_scene.get_node("stage")
	var forest = stage.get_node("forest")
	if toggled_on:		
		forest.visible = true
	else:
		forest.visible = false
