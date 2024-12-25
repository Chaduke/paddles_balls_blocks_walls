extends Node3D
var left_bounds = -18.5
var right_bounds = 12
var bottom_bounds = 0
var top_bounds = 29

func _input(event):
	if event is InputEventMouseMotion:
		var new_position_x = position.x + event.relative.x * 0.02
		var new_position_y = position.y - event.relative.y * 0.02
		if new_position_x > right_bounds: new_position_x = right_bounds
		if new_position_x < left_bounds: new_position_x = left_bounds
		if new_position_y > top_bounds: new_position_y = top_bounds
		if new_position_y < bottom_bounds: new_position_y = bottom_bounds
		position = Vector3(new_position_x,new_position_y,-5)
