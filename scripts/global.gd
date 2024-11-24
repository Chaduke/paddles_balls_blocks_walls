# global.gd
extends Node

var items_active = 0
var max_active_items = 4

func increment_items_active():
	if items_active < max_active_items:
		items_active += 1
		return true
	return false

func decrement_items_active():
	if items_active > 0:
		items_active -= 1
