extends Control

func _ready():
	setup_scene()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_accept"):
		take_thumbnail()

func take_thumbnail():	
	var image = $SubViewportContainer/SubViewport.get_texture().get_image()
	image.save_png("res://assets/images/thumbnails/stage" + str(Global.current_stage) + ".png")
	print("Thumbnail for stage " + str(Global.current_stage) + " saved.")
	Global.current_stage += 1
	if Global.current_stage < Global.total_stages:
		get_tree().reload_current_scene()

func setup_scene():	
	Global.creating_thumbnails = true 
	var stage = load("res://scenes/stage.tscn")	
	$SubViewportContainer/SubViewport.add_child(stage.instantiate())
	$Timer.start()

func _on_timer_timeout():
	take_thumbnail()
