# hand_cursor.gd
extends Node3D
class_name HandCursor

var left_bounds = -26
var right_bounds = 26
var bottom_bounds = -14
var top_bounds = 14

func _input(event):
	if event is InputEventMouseMotion:
		var new_position_x = position.x + event.relative.x * 0.01
		var new_position_y = position.y - event.relative.y * 0.01
		if new_position_x > right_bounds: new_position_x = right_bounds
		if new_position_x < left_bounds: new_position_x = left_bounds
		if new_position_y > top_bounds: new_position_y = top_bounds
		if new_position_y < bottom_bounds: new_position_y = bottom_bounds
		position = Vector3(new_position_x,new_position_y,-36)
		$location_label.text = str(position)
