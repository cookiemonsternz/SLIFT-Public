extends Control

@export var level_one_scene: PackedScene
@export var level_two_scene: PackedScene

var current_level: Node2D

func load_level_one():
	if current_level:
		current_level.queue_free()
	var level_one = level_one_scene.instantiate()
	add_child(level_one)
	current_level = level_one
	
	$MainMenu.queue_free()
	$Settings.hide()

func open_settings():
	show_settings()
	var tween = $Settings.create_tween()
	tween.tween_property($"Settings", "modulate", Color(1,1,1,1), 1)

func close_settings():
	var tween = $Settings.create_tween()
	tween.tween_property($"Settings", "modulate", Color(1,1,1,0), 1)
	tween.finished.connect(hide_settings)

func hide_settings():
	$Settings.hide()

func show_settings():
	$Settings.show()
