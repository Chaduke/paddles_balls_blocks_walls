# click_to_continue_label.gd
extends Node3D

var lerping = false
const target_position = Vector3(-2,8,-36)
# var points_gained_scene = preload("res://scenes/timed_labels/points_gained_label.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector3(-2,40,-36)
	lerping = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if lerping:
		$location_label.text = str(position)
		if global_position.distance_to(target_position) > 1:
			var new_position = global_position.lerp(target_position, 0.1) 
			global_position = new_position
		else:
			lerping = false
	else:
		if Input.is_action_just_pressed("swing_paddle"):
			GameStateManager.main_scene.stage.load_next_stage()
