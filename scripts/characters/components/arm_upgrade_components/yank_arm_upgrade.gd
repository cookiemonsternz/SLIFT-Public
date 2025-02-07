class_name YankArmUpgrade extends ArmUpgrade

const YANK_AMOUNT = 800

var queue_yank: bool = false
var queued_target_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	upgrade_name = "YankArmUpgrade"

# Called once every process frame
#func update_process(player: Player, root: Node):
	#pass

# Called once every physics frame
func update_physics(player: Player, root: Node):
	if queue_yank:
		player.player_physics_follow.apply_impulse(player.player_physics_follow.global_position.direction_to(queued_target_pos).normalized() * YANK_AMOUNT)
		queue_yank = false

# Called when an arm is shot (not when it connects)
#func _on_arm_shot(side: int, player: Player, root: Node):
	#pass

# Called when an arm connects (e.g the spring is created)
func _on_arm_connected(side: int, target_position: Vector2, player: Player, root: Node):
	queue_yank = true
	queued_target_pos = target_position

# Called when an arm is released
#func _on_arm_released(side: int, player: Player, root: Node):
	#pass

# Called when the player recieves damage
#func _on_player_damaged(damage: float, damage_type: int, player: Player, root: Node):
	#pass

# Called when the player lands
#func _on_player_landed(player: Player, root: Node):
	#pass
