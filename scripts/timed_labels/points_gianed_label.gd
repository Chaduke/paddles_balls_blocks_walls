# points_gained_label.gd
extends Node3D

var lerping = false
const target_position = Vector3(-2,12.5,-36)
# var points_gained_scene = preload("res://scenes/timed_labels/points_gained_label.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lerping = true
	$Label3D.text = "Points gained : " + str(Global.get_stage().points_gained)

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
	pass
	#var new_scene = points_gained_scene.instantiate()
	#Global.get_stage().add_child(new_scene)
