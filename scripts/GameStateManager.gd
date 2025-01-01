extends Node

var main_scene
var current_stage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = get_tree().current_scene
