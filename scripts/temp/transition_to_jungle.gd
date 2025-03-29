extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	#print("HIHIHIHI")
	get_tree().get_first_node_in_group("SceneManager").load_level_two()
