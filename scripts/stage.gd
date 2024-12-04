# stage.gd
extends StaticBody3D

var current_blocks
var block_scene_paths = []
var non_blocks_count = 0

func _ready():
	add_scene_paths()
	load_stage()
	if not Global.show_background_3d:
		$background_3d.hide()

func add_scene_paths():
	for i in range(Global.total_stages):
		block_scene_paths.append("res://scenes/blocks_" + str(i) + ".tscn")
		
func load_blocks():
	# Remove previous stage's blocks  
	if current_blocks: 
		current_blocks.queue_free()
	var scene_path = block_scene_paths[Global.current_stage] 
	var new_blocks_scene = load(scene_path) 
	current_blocks = new_blocks_scene.instantiate() 
	add_child(current_blocks)

func set_non_blocks_count():
	# get count of metal blocks, flow arrows, etc
	non_blocks_count = 0
	for child in current_blocks.get_children():
		if child.name.begins_with("block_metal"):
			non_blocks_count+=1
		if child.name.begins_with("flow_arrows"):
			non_blocks_count+=1
			
func load_stage():
	load_blocks()
	$stage_label.text = "Stage " + str(Global.current_stage)
	set_non_blocks_count()	
	
func all_stages_cleared():
	cleanup_stage()	
	$all_stages_cleared_menu.show()
	
func stage_cleared():	
	cleanup_stage()	
	$stage_cleared_menu.show()
	
func cleanup_stage():
	Global.accumlated_time = $total_time_label.elapsed_time
	Global.stage_started = false
	var main_scene = get_tree().root.get_child(1)
	main_scene.remove_all_balls()
	clear_flow_arrows()
	clear_metal_blocks()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func clear_flow_arrows():	
	for child in current_blocks.get_children():
		if child.name.begins_with("flow_arrows"):
			child.queue_free()
			
func clear_metal_blocks():
	for child in current_blocks.get_children():
		if child.name.begins_with("block_metal"):
			child.queue_free()
				
func _process(_delta):	
	var blocks_count = current_blocks.get_child_count() - non_blocks_count
	# check if stage had been cleared 
	$blocks_left_label.text = "Blocks Left " + str(blocks_count)
	if current_blocks and blocks_count == 0:
		stage_cleared()
				
func load_next_stage():
	Global.current_stage += 1 
	if Global.current_stage == Global.total_stages:
		all_stages_cleared()
	else:
		get_tree().paused = false
		get_tree().reload_current_scene()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
