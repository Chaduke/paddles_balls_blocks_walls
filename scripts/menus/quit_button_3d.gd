# quit_button_3d.gd
extends Area3D
var spinning = false
var angle = 0
var timer_done = true
var current = null

func _process(delta: float) -> void:
	if spinning:
		angle += 30 * delta
		if angle > 6.28:
			angle = 0
			spinning = false
			$spin_timer.start()
			timer_done = false
		rotation.y = angle
		
	if Input.is_action_just_pressed("swing_paddle") and current:
		current = null
		get_tree().quit()
		
func _on_area_entered(area: Area3D) -> void:
	#print("Area : " + area.name + " entered mine")
	if area.name == "hand_cursor":
		current = area
		if not spinning and timer_done:
			get_parent().play_spin_sound()
			spinning = true

func _on_spin_timer_timeout() -> void:
	timer_done = true

func _on_area_exited(area: Area3D) -> void:
	if area == current:
		current = null
