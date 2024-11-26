extends StaticBody3D
var current_stage = 1
var current_blocks

var block_scene_paths = [ 
	"res://scenes/blocks_0.tscn", 
	"res://scenes/blocks_1.tscn"
	]
# Called when the node enters the scene tree for the first time.
func _ready():
	load_stage(current_stage)
	
func _process(_delta):
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
	else: 
		print("No more stages available") 

func on_stage_cleared(): 
	current_stage += 1 
	load_stage(current_stage)
