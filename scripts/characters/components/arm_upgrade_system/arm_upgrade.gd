class_name ArmUpgrade extends Node

@export var upgrade_name: String = ""
@export var texture: Texture2D

func update_process(player: Player, root: Node):
	pass

func update_physics(player: Player, root: Node):
	pass

func _on_arm_shot(side: Enums.Grapples, player: Player, root: Node):
	pass

func _on_arm_connected(side: Enums.Grapples, target_position: Vector2, target_body: PhysicsBody2D, player: Player, root: Node):
	pass

func _on_arm_released(side: Enums.Grapples, player: Player, root: Node):
	pass

func _on_player_damaged(damage: float, damage_type: Enums.DamageType, player: Player, root: Node):
	pass

func _on_player_landed(player: Player, root: Node):
	pass
