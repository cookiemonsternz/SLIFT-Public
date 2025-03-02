extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("SAVING")
		var image = get_viewport().get_texture().get_image()
		print(image)
		image.save_png("C:/Users/Christopher/Downloads/ss.png")
