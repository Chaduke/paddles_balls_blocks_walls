extends Node3D
var thumbnail_size = Vector2(334, 200)  # Set the size for thumbnails
var scenes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_stage = 1
	# add the block scene paths 
	for i in range(Global.total_stages):
		var scene_path = "res://scenes/stage_blocks/blocks_" + str(i) + ".tscn"
		scenes.append(scene_path)
		
	# Create and configure the Viewport
	var viewport_container = SubViewportContainer.new()
	add_child(viewport_container)
	var viewport = SubViewport.new()
	viewport.size = thumbnail_size
	viewport_container.add_child(viewport)
	
	# Create and configure the Camera
	var camera = Camera3D.new()
	viewport.add_child(camera)
	camera.current = true

	# Adjust camera properties as needed
	camera.transform.origin = Vector3(0, 23, 37)  # Example position
	camera.look_at(Vector3(0, 23, 0), Vector3.UP)
	
	# add the block scene 
	var block_scene = load(scenes[current_stage])
	var instance = block_scene.instantiate()
	viewport.add_child(instance)

	# Render the viewport to a texture
	await get_tree().idle_frame
	var texture = viewport.get_texture()
	
	# Save the texture as an image
	var image = texture.get_image()
	# image.flip_y()  # Flip the image if needed
	image.save_png("res://assets/images/thumbnails/stage" + str(current_stage) + ".png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
