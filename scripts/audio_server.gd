extends Node

# music 
var game_intro_music = preload("res://assets/music/game_intro1.mp3")
var intro1_music = preload("res://assets/music/intro1.mp3")
var intro2_music = preload("res://assets/music/intro2.mp3")
var stage3_music = preload("res://assets/music/stage3.mp3")
var stage5_music = preload("res://assets/music/intro5.mp3")

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

func _on_music_player_finished():
	if Global.current_stage == 1:
		if $music_player.stream == intro1_music:
			$music_player.stream = intro2_music
			$music_player.play()
			
func play_game_intro():
	$music_player.stream = game_intro_music
	$music_player.play()
