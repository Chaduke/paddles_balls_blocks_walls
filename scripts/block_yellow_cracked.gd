extends Area3D
@onready var emitter = $GPUParticles3D
@onready var model = $block_yellow2
var active = true

func _on_body_entered(_body):
	if active:
		$block_sound.play()
		emitter.emitting = true
		model.visible = false
		active = false
			
func _on_gpu_particles_3d_finished():
	queue_free()
