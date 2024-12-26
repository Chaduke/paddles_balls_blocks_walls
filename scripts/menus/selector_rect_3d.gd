# selector_rect_3d.gd
extends Area3D
var current = null
var lerping = false
var target_position = Vector3(0,0,0)
var move_down = true
@export var id = 0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("swing_paddle") and current and not lerping:
		get_parent().play_sliding_sound()
		get_parent().slider_changed(id,move_down)
		target_position = global_position
		if move_down:
			target_position.y-=1.25
			move_down=false
		else:
			target_position.y+=1.25
			move_down=true
		lerping = true
	if lerping: move_to_target()

func _on_area_entered(area: Area3D) -> void:
	if area.name == "hand_cursor":
		current = area

func _on_area_exited(area: Area3D) -> void:
	if area == current:
		current = null
	
func move_to_target():
	var current_position = global_transform.origin
	if current_position.distance_to(target_position) > 0.01:
		# Interpolate towards target position 
		var new_position = current_position.lerp(target_position, 0.1) 
		global_transform.origin = new_position
	else: 
		lerping = false
