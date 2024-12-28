extends Node3D
var angle = 0.0
var spin_sound = preload("res://assets/wave/sword_swipe.wav")
var click_sound = preload("res://assets/wave/keyboard_click.wav")
var sliding_sound = preload("res://assets/wave/sliding.wav")
var active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	angle+=delta * 0.5
	if angle > 360:
		angle = 0.0
	$title_3d.rotation.y = sin(angle) * 0.3
	
func start_game():
	active = false
	var camera = Global.get_main().get_node("camera")
	camera.target_position = Vector3(0,15,0)
	camera.lerping = true
	$play_button_3d.get_node("Label3D").text = "Resume Game"
	Global.game_started = true
	Global.stage_selected = false
	Global.enable_cursor(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.get_main().set_globals()
	hide_labels()
	Global.set_paused(false)

func hide_labels():
	$game_mode_label.hide()
	$arcade_label.hide()
	$timed_label.hide()
	$selector_rect_3d.hide()
	$selector_rect_3d2.hide()
	$arcade_desc_label.hide()
	$timed_desc_label.hide()
	$stages_label.hide()
	$old_label.hide()
	$new_label.hide()
	$old_desc_label.hide()
	$new_desc_label.hide()
	
func play_spin_sound():
	$AudioStreamPlayer.stream = spin_sound
	$AudioStreamPlayer.play()

func play_click_sound():
	$AudioStreamPlayer.stream = click_sound
	$AudioStreamPlayer.play()
	
func play_sliding_sound():
	$AudioStreamPlayer.stream = sliding_sound
	$AudioStreamPlayer.play()
	
func slider_changed(id,moved_down):
	if id == 0:
		if moved_down:
			Global.stages_mode = Global.NEW
			$new_desc_label.show()
			$old_desc_label.hide()
		else:
			Global.stages_mode = Global.OLD
			$new_desc_label.hide()
			$old_desc_label.show()
	elif id == 1:
		if moved_down:
			Global.game_mode = Global.TIMED
			$timed_desc_label.show()
			$arcade_desc_label.hide()
		else:
			Global.game_mode = Global.ARCADE
			$timed_desc_label.hide()
			$arcade_desc_label.show()
