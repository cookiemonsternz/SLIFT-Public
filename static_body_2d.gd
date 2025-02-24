extends StaticBody2D
@export var distance: int

func _ready() -> void:
	move_right()
	
func move_right():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(distance,0), distance / 500)
	tween.tween_callback(move_left)
func move_left():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(-distance,0), distance / 500)
	tween.tween_callback(move_right)
