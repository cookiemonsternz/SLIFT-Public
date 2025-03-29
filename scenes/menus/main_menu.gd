extends MarginContainer

signal open_settings
signal play_game

func _on_options_button_pressed() -> void:
	open_settings.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	play_game.emit()
	get_tree().get_first_node_in_group("SceneManager").del_menus()
