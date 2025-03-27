extends Control

@export var level_one_scene: PackedScene
@export var level_two_scene: PackedScene

@export var death_screen_scene: PackedScene

var current_level_index: int = 0
var current_level: Node2D

func load_level_one():
	if current_level:
		current_level.queue_free()
	var level_one = level_one_scene.instantiate()
	add_child(level_one)
	current_level = level_one
	current_level_index = 1
	if get_child_count() > 1:
		$MainMenu.queue_free()
		$Settings.queue_free()

func load_level_two():
	current_level.queue_free()
	create_timer(0.1, load_level_two_callback)
	

func load_level_two_callback(timer: Timer):
	var level_two = level_two_scene.instantiate()
	add_child(level_two)
	current_level = level_two
	current_level_index = 2
	#$MainMenu.hide()
	#$Settings.hide()
	timer.queue_free()

func create_timer(length, callback):
	var timer = Timer.new()
	timer.autostart = false
	timer.one_shot = true
	add_child(timer)
	
	timer.wait_time = length
	timer.timeout.connect(callback.bind(timer))
	timer.start()

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

func show_death_screen():
	var death_screen = death_screen_scene.instantiate()
	add_child(death_screen)
	death_screen.modulate = Color(1, 1, 1, 0)
	var tween = death_screen.create_tween()
	tween.tween_property(death_screen, "modulate", Color(1,1,1,1), 1.0)
	

func restart_level():
	current_level.queue_free()
	match current_level_index:
		1:
			load_level_one()
		2:
			load_level_two()
	
