extends Control
var previous_menu = null

func _process(_delta):
	if visible:
		if Input.is_action_just_pressed("ui_cancel"):
			hide()
			if previous_menu:
				previous_menu.show()
				if previous_menu.name=="main_menu":
					previous_menu.elapsed_time = 0.0
		elif Input.is_action_just_pressed("ui_accept"):
			get_tree().quit()
