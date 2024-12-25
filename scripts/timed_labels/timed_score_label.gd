# timed_score_label.gd
extends Node3D

var velocity = Vector3(0,0,0)
var acceleration = Vector3(0,0,0)
var score = 0
var lerping = false
var target_position = Vector3(0,0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	acceleration.x = randf_range(-5,5)
	acceleration.y = randf_range(-5,5)
	velocity.x = -acceleration.x
	velocity.y = -acceleration.y
	target_position = Global.get_stage().get_node("score_label").global_position

func _process(delta: float) -> void:
	if lerping:
		if global_position.distance_to(target_position) > 1:
			var new_position = global_position.lerp(target_position, 0.1) 
			global_position = new_position
		else:
			Global.update_score(score)
			queue_free()
	velocity += acceleration * delta
	position += velocity * delta

func _on_timer_timeout() -> void:
	lerping = true
	# print("Lerp Started - My Position:" + str(global_position) + " Target:" + str(target_position))

func set_score(value):
	score = value
	$Label3D.text = str(value)
