extends StaticBody3D
var current_stage = 1
var current_blocks
var stages_available = true
var total_stages = 3
var block_scene_paths = []

func add_scene_paths():
	for i in range(total_stages):
		block_scene_paths.append("res://scenes/blocks_" + str(i) + ".tscn")
			
# Called when the node enters the scene tree for the first time.
func _ready():
	add_scene_paths()
	load_stage(current_stage)
	
func _process(_delta):
	if stages_available:
		if current_blocks and current_blocks.get_child_count() == 0:
			on_stage_cleared()

func load_stage(stage_number): 
	if current_blocks: 
		current_blocks.queue_free() # Remove previous stage's blocks 
	if stage_number - 1 < block_scene_paths.size(): 
		var scene_path = block_scene_paths[stage_number - 1] 
		var new_blocks_scene = load(scene_path) 
		current_blocks = new_blocks_scene.instantiate() 
		add_child(current_blocks)
		$stage_label.text = "Stage " + str(current_stage - 1)
	else: 
		print("No more stages available")
		stages_available = false

func on_stage_cleared(): 
	current_stage += 1 
	load_stage(current_stage)
