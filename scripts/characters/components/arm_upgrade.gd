class_name ArmUpgrade extends Node

var upgrade_name = "REPLACE_ME"

enum Grapples {
	Left,
	Right
}

enum DamageType {
	World,
	Enemy,
	Obstacle,
	Light
}

func update_process(player: Player, root: Node):
	pass

func update_physics(player: Player, root: Node):
	pass

func _on_arm_shot(side: int, player: Player, root: Node):
	pass

func _on_arm_connected(side: int, target_position: Vector2, player: Player, root: Node):
	pass

func _on_arm_released(side: int, player: Player, root: Node):
	pass

func _on_player_damaged(damage: float, damage_type: int, player: Player, root: Node):
	pass

func _on_player_landed(player: Player, root: Node):
	pass
