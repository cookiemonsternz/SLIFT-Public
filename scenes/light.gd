extends Area2D

var light_exposure = 0
@export var exposure_data: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		exposure_data.start()
	

func _on_body_exited(body: Node2D) -> void:
	exposure_data.stop()


func _on_exposure_timeout() -> void:
	light_exposure += 1
	get_tree().get_first_node_in_group("Player").light_exposure += 1
