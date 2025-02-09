extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("button_activate"):
		print("Enter")
		GlobalButton.button_active = true



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("button_activate"):
		print("Exit")
		GlobalButton.button_active = false
