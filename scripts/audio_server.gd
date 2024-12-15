# audio_server.gd

# this is experimental, not even sure if its a good idea
# I think for music it could work but sounds seem to work 
# better attached to individual scenes that make them 
# probably should rename this to "music server" or "music manager"
extends Node

# music 
var game_intro_music = preload("res://assets/music/game_intro1.mp3")
var intro1_music = preload("res://assets/music/intro1.mp3")
var stage3_music = preload("res://assets/music/stage3.mp3")
var stage5_music = preload("res://assets/music/intro5.mp3")
var stage6_music = preload("res://assets/music/intro6.mp3")
var stage7_music = preload("res://assets/music/intro7.mp3")

func play_music():
	if Global.current_stage == 1:
		$music_player.stream = intro1_music
		$music_player.play()
	elif Global.current_stage == 3:
		$music_player.stream = stage3_music
		$music_player.play()
	elif Global.current_stage == 5:
		$music_player.stream = stage5_music
		$music_player.play()
	elif Global.current_stage == 6:
		$music_player.stream = stage6_music
		$music_player.play()
	elif Global.current_stage == 7:
		$music_player.stream = stage7_music
		$music_player.play()

func _on_music_player_finished():
	$replay_timer.start()
			
func play_game_intro():
	$music_player.stream = game_intro_music
	$music_player.play()

func _on_replay_timer_timeout() -> void:
	play_music()
