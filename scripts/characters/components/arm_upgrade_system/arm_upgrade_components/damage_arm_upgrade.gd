class_name DamageArmUpgrade extends ArmUpgrade

var loaded_texture: Texture = preload("res://assets/Images/damage_arm_upgrade.png")

func _init():
	texture = loaded_texture
	upgrade_name = "Damage Arm Upgrade"

# Called once every process frame
# func update_process(player: Player, root: Node):
# 	pass

# Called once every physics frame
# func update_physics(player: Player, root: Node):
# 	pass

# Called when an arm is shot (not when it connects)
# func _on_arm_shot(side: int, player: Player, root: Node):
# 	pass

# Called when an arm connects (e.g the spring is created)
func _on_arm_connected(side: int, target_position: Vector2, player: Player, root: Node):
	for child in player.grapple_targets[side].get_children():
		if child is HealthComponent:
			child.damage(1, Enums.DamageType.World, self)

# Called when an arm is released
# func _on_arm_released(side: int, player: Player, root: Node):
# 	pass

# Called when the player recieves damage
# func _on_player_damaged(damage: float, damage_type: int, player: Player, root: Node):
# 	pass

# Called when the player lands
# func _on_player_landed(player: Player, root: Node):
# 	pass
