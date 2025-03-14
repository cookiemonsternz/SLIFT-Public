extends AnimatedSprite2D

var direction = Vector2(0,0)

func _ready() -> void:
	play("Idle")

func _on_player_detected(_body) -> void:
	print("HI")
	play("Transition")
	var play_flying = func():
		play("Flying")
	animation_finished.connect(play_flying)
	direction = Vector2(randf_range(1, 3), -randf_range(1, 3)) * 2.5

func _physics_process(delta: float) -> void:
	position += direction
