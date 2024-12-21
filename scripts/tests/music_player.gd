extends Control
var current_music
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicServer.play_music()
	next_song()
	Global.stage_started = true
	var replay_timer = MusicServer.get_node("replay_timer")
	replay_timer.wait_time = 1.0
	
func next_song():	
	current_music = MusicServer.current_music
	$song_playing_label.text = "Song " + str(current_music)
	$played_size.text = "Songs Played " + str(len(MusicServer.stage_played))

func _process(_delta: float) -> void:
	if MusicServer.current_music != current_music:
		next_song()
