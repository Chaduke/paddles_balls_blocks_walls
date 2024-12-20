# music_server.gd

# this is experimental, not even sure if its a good idea
# I think for music it could work but sounds seem to work 
# better attached to individual scenes that make them 
# probably should rename this to "music server" or "music manager"
extends Node

# music 
var game_intro_music = preload("res://assets/music/game_intro1.mp3")

var intro_paths = []
var stage_paths = []

var intro_played = []
var stage_played = []

var random_music = true

func _ready() -> void:
	setup_music_paths()
	
func setup_music_paths():
	for i in range(Global.total_stages):
		intro_paths.append("res://assets/music/intro" + str(i + 1) + ".mp3")
		stage_paths.append("res://assets/music/stage" + str(i + 1) + ".mp3")

func play_music():
	var i = Global.current_stage-1
	if random_music: i = get_random_music()
	var stage_music_path = stage_paths[i]
	if ResourceLoader.exists(stage_music_path):
		$music_player.stream = load(stage_paths[i])
		$music_player.play()

func play_intro_music():
	var i = Global.current_stage-1
	if random_music: i = get_random_music()
	var intro_music_path = intro_paths[i]
	if ResourceLoader.exists(intro_music_path):
		$music_player.stream = load(intro_paths[i])
		$music_player.play()

func _on_music_player_finished():
	if Global.stage_started:
		$replay_timer.start()
				
func play_game_intro():
	$music_player.stream = game_intro_music
	$music_player.play()

func _on_replay_timer_timeout() -> void:
	play_music()
		
func get_random_music():
	var found = false	
	var i = 0
	var rng = RandomNumberGenerator.new() 
	rng.randomize() 
	var stage_music_path = ""	
	while not found:
		# pick a random number
		i = rng.randi_range(0,Global.total_stages-1)
		if i not in stage_played:
			stage_music_path = stage_paths[i]
			if ResourceLoader.exists(stage_music_path): found = true
			stage_played.append(i)
			if len(stage_played) > Global.total_stages-1: stage_played.clear()
	return i
