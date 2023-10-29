class_name Heart

extends Area2D


func _on_body_entered(_body: Node2D):
	queue_free()
	var hearts_count: int = get_tree().get_nodes_in_group("Hearts").size()
	if hearts_count == 1:
		print("Level complete")
