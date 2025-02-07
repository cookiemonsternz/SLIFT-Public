class_name ArmUpgradeComponent extends Node

var installed_upgrades_left: Array[ArmUpgrade] = []
var installed_upgrades_right: Array[ArmUpgrade] = []

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

func add_upgrade(side: int, index: int, upgrade: ArmUpgrade):
	print(upgrade.upgrade_name)
	if side == Grapples.Left:
		installed_upgrades_left.insert(index, upgrade)
	elif side == Grapples.Right:
		installed_upgrades_right.insert(index, upgrade)

func remove_upgrade(side: int, index: int):
	if side == Grapples.Left:
		installed_upgrades_left.remove_at(index)
	elif side == Grapples.Right:
		installed_upgrades_right.remove_at(index)

func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	for upgrade in installed_upgrades_left:
		if upgrade.has_method("update_process"):
			upgrade.update_process(player, root)
	for upgrade in installed_upgrades_right:
		if upgrade.has_method("update_process"):
			upgrade.update_process(player, root)

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	for upgrade in installed_upgrades_left:
		if upgrade.has_method("update_physics"):
			upgrade.update_physics(player, root)
	for upgrade in installed_upgrades_right:
		if upgrade.has_method("update_physics"):
			upgrade.update_physics(player, root)

func arm_shot(side: int):
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	if side == Grapples.Left:
		for upgrade in installed_upgrades_left:
			if upgrade.has_method("_on_arm_shot"):
				upgrade._on_arm_shot(side, player, root)
	elif side == Grapples.Right:
		for upgrade in installed_upgrades_right:
			if upgrade.has_method("_on_arm_shot"):
				upgrade._on_arm_shot(side, player, root)

func arm_connected(side: int, target_position: Vector2):
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	if side == Grapples.Left:
		for upgrade in installed_upgrades_left:
			if upgrade.has_method("_on_arm_connected"):
				upgrade._on_arm_connected(side, target_position, player, root)
	elif side == Grapples.Right:
		for upgrade in installed_upgrades_right:
			if upgrade.has_method("_on_arm_connected"):
				upgrade._on_arm_connected(side, target_position, player, root)

func arm_released(side: int):
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	if side == Grapples.Left:
		for upgrade in installed_upgrades_left:
			if upgrade.has_method("_on_arm_released"):
				upgrade._on_arm_released(side, player, root)
	elif side == Grapples.Right:
		for upgrade in installed_upgrades_right:
			if upgrade.has_method("_on_arm_released"):
				upgrade._on_arm_released(side, player, root)

func player_damaged(damage: float, damage_type: int):
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	for upgrade in installed_upgrades_left:
		if upgrade.has_method("_on_player_damaged"):
			upgrade._on_player_damaged(damage, damage_type, player, root)
	for upgrade in installed_upgrades_right:
		if upgrade.has_method("_on_player_damaged"):
			upgrade._on_player_damaged(damage, damage_type, player, root)

func player_landed():
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	for upgrade in installed_upgrades_left:
		if upgrade.has_method("_on_player_landed"):
			upgrade._on_player_landed(player, root)
	for upgrade in installed_upgrades_right:
		if upgrade.has_method("_on_player_landed"):
			upgrade._on_player_landed(player, root)
