extends Area2D

@export var exposure_delay_timer: Timer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		exposure_delay_timer.start()

func _on_body_exited(body: Node2D) -> void:
	exposure_delay_timer.stop()

func _on_exposure_timeout() -> void:
	get_tree().get_first_node_in_group("Player").light_exposure += 1
