extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fall(body: Node2D):
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.current_move_mode = Enums.MoveModes.DASH
	play("fallingthing")
	create_tween().tween_interval(0.05).finished.connect(undash)


func undash():
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.velocity = Vector2.ZERO
	player.current_move_mode = Enums.MoveModes.GROUND
