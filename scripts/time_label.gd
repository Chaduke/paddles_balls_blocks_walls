# time_label.gd
extends Label3D
var elapsed_time = 0.0

func _ready():
	# Initialize the time_label text
	text = Global.format_time(elapsed_time)

func _process(delta):
	if Global.stage_started:
		# Update the elapsed time
		elapsed_time += delta
		text = Global.format_time(elapsed_time)
