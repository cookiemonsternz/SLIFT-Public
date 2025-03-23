extends ColorRect

@export var backgrounds: Array[Node2D]
@export var background: Node2D

var collision_shape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape = $Area2D/CollisionShape2D
	color = Color(0,0,0,0)
	var shape = RectangleShape2D.new()
	shape.size = size
	collision_shape.shape = shape
	collision_shape.position = size/2

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entered area")
	for bg: Node2D in backgrounds:
		bg.hide()
	background.show()
