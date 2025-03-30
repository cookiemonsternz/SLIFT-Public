extends PanelContainer

var paused = false
var settings_open = false
@export var Settings: Control

func respawn():
	toggle_paused()

# Options
func _on_button_2_pressed() -> void:
	toggle_settings()

func toggle_settings():
	if settings_open:
		print("Closing SETTINGs")
		close_settings()
		settings_open = false
	else:
		print("OPENING SETTINGs")
		open_settings()
		settings_open = true

func hide_settings():
	Settings.hide()

func show_settings():
	Settings.show()

func open_settings():
	show_settings()
	var tween = create_tween()
	tween.tween_property(Settings, "modulate", Color(1.,1.,1.,1.), 1.)

func close_settings():
	print("HIHISHADISHDKJASD")
	var tween = create_tween()
	tween.tween_property(Settings, "modulate", Color(1,1,1,0), 1)
	tween.finished.connect(hide_settings)

# Quit
func _on_button_3_pressed() -> void:
	get_tree().get_first_node_in_group("SceneManager").to_menu()

func toggle_paused():
	if paused:
		get_tree().paused = false
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,0.0), 0.2)
		tween.finished.connect(hide)
		var set_false = func():
			paused = false
		tween.finished.connect(set_false)
	else:
		get_tree().paused = true
		show()
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 0.2)
		var set_true = func():
			paused = true
		tween.finished.connect(set_true)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_paused()
