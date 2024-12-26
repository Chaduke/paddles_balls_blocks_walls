extends Node3D
var angle = 0.0
var spin_sound = preload("res://assets/wave/sword_swipe.wav")
var click_sound = preload("res://assets/wave/keyboard_click.wav")
var sliding_sound = preload("res://assets/wave/sliding.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	angle+=delta * 0.5
	if angle > 360:
		angle = 0.0
	$title_3d.rotation.y = sin(angle) * 0.3

func start_game():
	var camera = Global.get_main().get_node("camera")
	camera.target_position = Vector3(0,15,0)
	camera.lerping = true
	$play_button_3d.get_node("Label3D").text = "Resume Game"
	get_tree().paused = false
	Global.game_started = true
	Global.stage_selected = false
	Global.toggle_cursor()

func play_spin_sound():
	$AudioStreamPlayer.stream = spin_sound
	$AudioStreamPlayer.play()

func play_click_sound():
	$AudioStreamPlayer.stream = click_sound
	$AudioStreamPlayer.play()
	
func play_sliding_sound():
	$AudioStreamPlayer.stream = sliding_sound
	$AudioStreamPlayer.play()