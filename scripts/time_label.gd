extends Label3D

# Time variables
var elapsed_time = 0.0
var minutes = 0
var seconds = 0
var hundredths = 0
var game_started = false

func _ready():
	# Initialize the time_label text
	text = format_time(elapsed_time)

func _process(delta):
	if game_started:
		# Update the elapsed time
		elapsed_time += delta
			
		# Calculate minutes, seconds, and hundredths
		minutes = int(elapsed_time / 60)
		seconds = int(elapsed_time) % 60
		hundredths = int(elapsed_time * 100) % 100
		
		# Update the label text
		text = "Time " + str(minutes) + "m " + str(seconds) + "s " + format_hundredths(hundredths)

func format_time(time):
	# Calculate minutes, seconds, and hundredths from the time
	var mins = int(time / 60)
	var secs = int(time) % 60
	var hund = int(time * 100) % 100
	return "Time " + str(mins) + "m " + str(secs) + "s " + format_hundredths(hund)

func format_hundredths(h): 
	# Format hundredths to always be two digits 
	var hundredths_str = str(h) 
	if h < 10: 
		hundredths_str = "0" + hundredths_str 
	return hundredths_str
