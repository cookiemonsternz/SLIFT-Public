extends CollisionShape2D
@export var collision: CollisionObject2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalButton.button_active == true:
		collision.queue_free() 
