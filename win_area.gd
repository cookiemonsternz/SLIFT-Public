extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("Winner")
	get_tree().get_first_node_in_group("Player").win_screen.visible = true
	get_tree().get_first_node_in_group("Player").win_button.disabled = false
