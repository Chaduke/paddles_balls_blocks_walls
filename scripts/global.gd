# global.gd
extends Node

var current_stage = 1
var current_ball_size = 2
var infinite_balls = false
var game_started = false

var slot1 = false
var slot2 = false
var slot3 = false
var slot4 = false

func find_free_slot():
	if not slot1:
		slot1 = true
		return 1
	elif not slot2:
		slot2 = true
		return 2
	elif not slot3:
		slot3 = true
		return 3
	elif not slot4:
		slot4 = true
		return 4
	else:
		return 0
		
func set_slot_inactive(slot):
	if slot == 1:
		slot1 = false
	elif slot == 2: 
		slot2 = false
	elif slot == 3:
		slot3 = false
	elif slot == 4: 
		slot4 = false
