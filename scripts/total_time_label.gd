# total_time_label.gd
extends Label3D

var elapsed_time = 0.0

func _ready():
	# Initialize the time_label text
	if Global.stage_selected:
		text = "Time trial only"
	else:
		text = Global.format_time(Global.accumlated_time)
		elapsed_time = Global.accumlated_time

func _process(delta):
	if Global.stage_started and not Global.stage_selected:
		# Update the elapsed time
		elapsed_time += delta
		text = Global.format_time(elapsed_time)
