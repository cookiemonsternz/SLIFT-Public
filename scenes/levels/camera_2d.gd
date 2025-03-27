extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_P):
		var ss := get_viewport().get_texture()
		ss.get_image().save_png("C:/Users/Christopher/Downloads/ssssss.png")
