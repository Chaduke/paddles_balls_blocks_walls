extends StaticBody3D

var current_blocks
var stages_available = true
var total_stages = 4
var block_scene_paths = []

func add_scene_paths():
	for i in range(total_stages):
		block_scene_paths.append("res://scenes/blocks_" + str(i) + ".tscn")
			
# Called when the node enters the scene tree for the first time.
func _ready():
	add_scene_paths()
	load_stage(Global.current_stage)
	
func _process(_delta):
	if stages_available:
		if current_blocks and current_blocks.get_child_count() == 0:
			on_stage_cleared()
	else:
		if Input.is_action_just_pressed("spawn_ball") \
		or Input.is_action_just_pressed("swing_paddle"):
			stages_available = true			
			Global.current_stage =  2
			$all_stages_clear_label.visible = false
			$all_stages_clear_label2.visible = false
			get_tree().reload_current_scene()
			load_stage(Global.current_stage)
		
	if (Input.is_action_just_pressed("spawn_ball") \
	or Input.is_action_just_pressed("swing_paddle")) \
	and $stage_clear_label.visible == true:
		load_next_stage()

func load_stage(stage_number): 
	if current_blocks: 
		current_blocks.queue_free() # Remove previous stage's blocks 
	if stage_number - 1 < block_scene_paths.size(): 
		var scene_path = block_scene_paths[stage_number - 1] 
		var new_blocks_scene = load(scene_path) 
		current_blocks = new_blocks_scene.instantiate() 
		add_child(current_blocks)
		$stage_label.text = "Stage " + str(Global.current_stage - 1)
	else: 
		$all_stages_clear_label.visible = true
		$all_stages_clear_label2.visible = true
		stages_available = false

func on_stage_cleared():
	$stage_clear_label.text = "Stage " + str(Global.current_stage) + " Cleared!"
	$stage_clear_label.visible = true
	$stage_clear_label2.visible = true

func load_next_stage():
	$stage_clear_label.visible = false
	$stage_clear_label2.visible = false
	Global.current_stage += 1 
	get_tree().reload_current_scene()
	load_stage(Global.current_stage)