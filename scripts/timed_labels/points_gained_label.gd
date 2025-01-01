# points_gained_label.gd
extends Node3D

var lerping = false
const target_position = Vector3(-2,12.5,-36)
var click_to_continue_scene = preload("res://scenes/timed_labels/click_to_continue_label.tscn")

func _ready() -> void:
	lerping = true
	Vector3(25,12.5,-36)
	$Label3D.text = "Points gained : " + str(GameStateManager.main_scene.stage.points_gained)

func _process(_delta: float) -> void:
	if lerping:
		if global_position.distance_to(target_position) > 1:
			var new_position = global_position.lerp(target_position, 0.1) 
			global_position = new_position
		else:
			lerping = false
			$Timer.start()

func _on_timer_timeout() -> void:	
	var new_scene = click_to_continue_scene.instantiate()
	GameStateManager.main_scene.stage.add_child(new_scene)
