extends AnimationPlayer

func fall(_body: Node2D):
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.current_move_mode = Enums.MoveModes.DASH
	play("fallingthing")
	create_tween().tween_interval(0.05).finished.connect(undash)


func undash():
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.velocity = Vector2.ZERO
	player.current_move_mode = Enums.MoveModes.GROUND
