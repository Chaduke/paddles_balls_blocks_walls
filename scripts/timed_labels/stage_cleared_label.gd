# stage_cleared_label.gd
extends Node3D

var lerping = false
const target_position = Vector3(-2,16.5,-36)
var blocks_cleared_scene = preload("res://scenes/timed_labels/blocks_cleared_label.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lerping = true
	$Label3D.text = "Stage " + str(Global.current_stage) + " Cleared!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if lerping:
		if global_position.distance_to(target_position) > 1:
			var new_position = global_position.lerp(target_position, 0.1) 
			global_position = new_position
		else:
			lerping = false
			$Timer.start()

func _on_timer_timeout() -> void:
	var new_scene = blocks_cleared_scene.instantiate()
	GameStateManager.main_scene.stage.add_child(new_scene)
