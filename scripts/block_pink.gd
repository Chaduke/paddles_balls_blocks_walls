extends StaticBody3D
@export var item_type : String = "Grower" 
var item_scene = preload("res://scenes/pickup_item.tscn")

func _on_tree_exiting():
	var item_instance = item_scene.instantiate()
	item_instance.position = position
	item_instance.position.x -= 18.5
	item_instance.position.z = -37
	item_instance.item_type = item_type
	get_tree().root.get_child(0).add_child(item_instance)
	print("Item added at " + str(position))
