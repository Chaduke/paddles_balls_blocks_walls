extends Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	$block_sound.play()
	$GPUParticles3D.emitting = true

func _on_gpu_particles_3d_finished():
	queue_free()
