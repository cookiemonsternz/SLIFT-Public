extends Control

signal close_settings
@export var resolutions_option_button: OptionButton
const RESOLUTION_DICTIONARY: Dictionary = {
	"1152 x 648": Vector2i(1152, 648),
	"1280 x 720": Vector2i(1280, 720),
	"1600 x 900": Vector2i(1600, 900),
	"1920 x 1080": Vector2i(1920, 1080),
	"2560 x 1440": Vector2i(2560, 1440),
	"3840 x 2160": Vector2i(3840, 2160),
}

func _ready():
	for i in len(RESOLUTION_DICTIONARY.keys()):
		resolutions_option_button.add_item(RESOLUTION_DICTIONARY.keys()[i], i)
	resolutions_option_button.select(4)
	

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_mute_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

func _on_resolutions_option_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	
	#var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	#var window_size = get_window().get_size_with_decorations()
	#get_window().set_position(screen_center - window_size / 2)

func _on_display_mode_option_button_item_selected(index: int) -> void:
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			resolutions_option_button.disabled = true
			var text = str(round(Vector2(DisplayServer.window_get_size())/10.0)*10)
			text = text.substr(1, len(text)-2)
			text = text.split(",")[0]+" x"+text.split(",")[1]
			resolutions_option_button.text = text
		1: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[resolutions_option_button.selected])
			resolutions_option_button.disabled = false
		2: # Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[resolutions_option_button.selected])
			resolutions_option_button.disabled = false
		3: # Borderless Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			resolutions_option_button.disabled = true
			var text = str(round(Vector2(DisplayServer.window_get_size())/10.0)*10)
			text = text.substr(1, len(text)-2)
			text = text.split(",")[0]+" x"+text.split(",")[1]
			resolutions_option_button.text = text

func _on_back_button_pressed() -> void:
	close_settings.emit()
