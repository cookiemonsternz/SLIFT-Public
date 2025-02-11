# meta-default: true
# meta-name: Arm Upgrade
# meta-description: Contains base functions for all arm upgrades
# meta-space-indent: 4

class_name CHANGEME extends ArmUpgrade

var loaded_texture: Texture = preload("res://path/to/texture.png")

func _ready():
    texture = loaded_texture
    upgrade_name = "CHANGEME"

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
# func _on_arm_connected(side: int, target_position: Vector2, player: Player, root: Node):
# 	pass

# Called when an arm is released
# func _on_arm_released(side: int, player: Player, root: Node):
# 	pass

# Called when the player recieves damage
# func _on_player_damaged(damage: float, damage_type: int, player: Player, root: Node):
# 	pass

# Called when the player lands
# func _on_player_landed(player: Player, root: Node):
# 	pass
