extends Node3D
var angle = 0.0

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
