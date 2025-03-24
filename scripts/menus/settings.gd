extends Control

signal close_settings
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_mute_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

func _on_resolutions_option_button_item_selected(index: int) -> void:
	print(index)
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(3840, 2160))
		1:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
		2:	
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		3:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		4:
			DisplayServer.window_set_size(Vector2i(1280, 720))

func _on_display_mode_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back_button_pressed() -> void:
	close_settings.emit()
