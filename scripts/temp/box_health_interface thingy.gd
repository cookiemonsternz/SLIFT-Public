extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var onDeath = func(damage, damage_type, damage_source):
		queue_free()
	$"Health Component".entity_died.connect(onDeath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
