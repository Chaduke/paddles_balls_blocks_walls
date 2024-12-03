# stage.gd
extends StaticBody3D

var current_blocks
var stages_available = true
var block_scene_paths = []
var non_blocks_count = 0

func _ready():
	add_scene_paths()
	load_stage()

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
	$all_stages_clear_label.show()
	$all_stages_clear_label2.show()
	stages_available = false

func stage_cleared():
	$stage_clear_label.text = "Stage " + str(Global.current_stage) + " Cleared!"
	$stage_clear_label.show()
	$stage_clear_label2.show()
	Global.accumlated_time = $total_time_label.elapsed_time
	Global.stage_started = false
	var main_scene = get_tree().root.get_child(1)
	main_scene.remove_all_balls()
	clear_flow_arrows()
	clear_metal_blocks()
			
func clear_flow_arrows():	
	for child in current_blocks.get_children():
		if child.name.begins_with("flow_arrows"):
			child.queue_free()
			
func clear_metal_blocks():
	for child in current_blocks.get_children():
		if child.name.begins_with("block_metal"):
			child.queue_free()
				
func _process(_delta):
	if stages_available:
		var blocks_count = current_blocks.get_child_count() - non_blocks_count
		# check if stage had been cleared 
		if current_blocks and blocks_count == 0:
			stage_cleared()
	else:		
		if Input.is_action_just_pressed("swing_paddle"):
			stages_available = true
			Global.current_stage = 1
			$all_stages_clear_label.hide()
			$all_stages_clear_label2.hide()
			get_tree().reload_current_scene()
			#load_stage()
		else: 
			if Input.is_action_just_pressed("swing_paddle") and $stage_clear_label.visible == true:
				load_next_stage()
				
func load_next_stage():
	$stage_clear_label.hide()
	$stage_clear_label2.hide()
	Global.current_stage += 1 
	if Global.current_stage == Global.total_stages:
		all_stages_cleared()
	else:
		get_tree().reload_current_scene()
		#load_stage()
