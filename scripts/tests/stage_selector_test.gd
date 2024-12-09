extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
