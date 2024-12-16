extends Node3D
class_name HelpMenu

var active 

func _ready() -> void:
	active = false
	
func _process(_delta: float) -> void:
	if active:
		$block_yellow.rotate(Vector3(0.0,1.0,0.0),0.015)
		$cracked_yellow.rotate(Vector3(0.0,1.0,0.0),0.02)
		$block_blue.rotate(Vector3(0.0,1.0,0.0),0.025)
		if Input.is_action_pressed("ui_text_caret_left"):
			$the_dude.position.x -= 0.1
		elif Input.is_action_pressed("ui_text_caret_right"):
			$the_dude.position.x += 0.1
