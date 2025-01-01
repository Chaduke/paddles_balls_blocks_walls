extends Node3D
class_name HelpMenu

var active 
var elapsed_time = 0.0

func _ready() -> void:
	active = false
	
func _process(delta: float) -> void:
	elapsed_time+=delta
	if active:
		$yellow_blocks/block_yellow.rotate(Vector3(0.0,1.0,0.0),0.015)
		$yellow_blocks/cracked_yellow.rotate(Vector3(0.0,1.0,0.0),0.02)
		$blue_blocks/block_blue.rotate(Vector3(0.0,1.0,0.0),0.025)
		$blue_blocks/cracked_blue.rotate(Vector3(0.0,1.0,0.0),0.03)
		$pink_blocks/block_pink.rotate(Vector3(0.0,1.0,0.0),0.035)
		$pink_blocks/cracked_pink.rotate(Vector3(0.0,1.0,0.0),0.04)
		$clear_blocks/blue_ball_block.rotate(Vector3(0.0,1.0,0.0),0.05)
		$clear_blocks/pink_ball_block.rotate(Vector3(0.0,1.0,0.0),0.055)
		$metal_block.rotate(Vector3(0.0,1.0,0.0),0.05)
		$magnetic_block.rotate(Vector3(0.0,1.0,0.0),0.045)
		$shielded_block.rotate(Vector3(0.0,1.0,0.0),0.04)
		
		if Input.is_action_just_pressed("menu_2"):
			active = false
			var camera = GameStateManager.main_scene.get_node("camera")
			var help_menu_2 = GameStateManager.main_scene.get_node("help_menu_2")
			camera.lerping = true
			camera.target_position = Vector3(45,45,0)
			help_menu_2.active = true
		if Global.game_started and elapsed_time > 0.1:
			if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("menu_1"):
				GameStateManager.main_scene.toggle_main_menu()
			
