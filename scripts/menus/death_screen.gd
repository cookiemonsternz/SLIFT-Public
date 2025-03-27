extends PanelContainer

func respawn():
	get_tree().get_first_node_in_group("SceneManager").restart_level()

# Options
func _on_button_2_pressed() -> void:
	pass # Replace with function body.

# Quit
func _on_button_3_pressed() -> void:
	get_tree().get_first_node_in_group("SceneManager").to_menu()
