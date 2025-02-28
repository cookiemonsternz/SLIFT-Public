class_name ArmUpgradeComponent extends Node

@export var arm_upgrade_ui: Control

var installed_upgrades_left := {}
var installed_upgrades_right := {}

var upgrade_pool: Array[ArmUpgrade] = []

func add_upgrade(side: int, index: int, upgrade: ArmUpgrade):
	print(upgrade.upgrade_name)
	if side == Enums.Grapples.Left:
		installed_upgrades_left[index] = upgrade
	elif side == Enums.Grapples.Right:
		installed_upgrades_right[index] = upgrade
	print([installed_upgrades_left, installed_upgrades_right])
	arm_upgrade_ui.update_slots([installed_upgrades_left, installed_upgrades_right])

func remove_upgrade(side: int, index: int):
	if side == Enums.Grapples.Left:
		installed_upgrades_left.erase(index)
	elif side == Enums.Grapples.Right:
		installed_upgrades_right.erase(index)
	arm_upgrade_ui.update_slots([installed_upgrades_left, installed_upgrades_right])

func move_upgrade(side1: int, index1: int, side2: int, index2: int):
	print("Moving from index ", index1, " side ", side1, " to index ", index2, " side ", side2)
	match side2:
		Enums.Grapples.Left:
			if installed_upgrades_left.has(index2):
				var cache_upgrade_1 = installed_upgrades_left[index1] if side1 == Enums.Grapples.Left else installed_upgrades_right[index1]
				if side1 == Enums.Grapples.Left:
					installed_upgrades_left[index1] = installed_upgrades_right[index2]
				else:
					installed_upgrades_right[index1] = installed_upgrades_right[index2]
				installed_upgrades_left[index2] = cache_upgrade_1
			else:
				installed_upgrades_left[index2] = installed_upgrades_left[index1] if side1 == Enums.Grapples.Left else installed_upgrades_right[index1]
				if side1 == Enums.Grapples.Right:
					installed_upgrades_right.erase(index1)
				else:
					installed_upgrades_left.erase(index1)
		Enums.Grapples.Right:
			if installed_upgrades_right.has(index2):
				var cache_upgrade_1 = installed_upgrades_right[index1] if side1 == Enums.Grapples.Right else installed_upgrades_left[index1]
				if side1 == Enums.Grapples.Right:
					installed_upgrades_right[index1] = installed_upgrades_right[index2]
				else:
					installed_upgrades_left[index1] = installed_upgrades_right[index2]
				installed_upgrades_right[index2] = cache_upgrade_1
			else:
				installed_upgrades_right[index2] = installed_upgrades_right[index1] if side1 == Enums.Grapples.Right else installed_upgrades_left[index1]
				if side1 == Enums.Grapples.Left:
					installed_upgrades_left.erase(index1)
				else:
					installed_upgrades_right.erase(index1)
	arm_upgrade_ui.update_slots([installed_upgrades_left, installed_upgrades_right])

func add_upgrade_pool(upgrade: ArmUpgrade):
	upgrade_pool.append(upgrade)
	arm_upgrade_ui.update_pool(upgrade_pool)

func remove_upgrade_pool(upgrade: ArmUpgrade):
	upgrade_pool.remove_at(upgrade_pool.find(upgrade))
	arm_upgrade_ui.update_pool(upgrade_pool)

###--- ARM UPGRADE CALLABLES ---###
# These functions are triggered by player events and are called on all installed upgrades


func _on_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	for upgrade in installed_upgrades_left.values():
		if upgrade.has_method("update_process"):
			upgrade.update_process(player, root)
	for upgrade in installed_upgrades_right.values():
		if upgrade.has_method("update_process"):
			upgrade.update_process(player, root)

func _on_physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	for upgrade in installed_upgrades_left.values():
		if upgrade.has_method("update_physics"):
			upgrade.update_physics(player, root)
	for upgrade in installed_upgrades_right.values():
		if upgrade.has_method("update_physics"):
			upgrade.update_physics(player, root)

func arm_shot(side: int):
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	if side == Enums.Grapples.Left:
		for upgrade in installed_upgrades_left.values():
			if upgrade.has_method("_on_arm_shot"):
				upgrade._on_arm_shot(side, player, root)
	elif side == Enums.Grapples.Right:
		for upgrade in installed_upgrades_right.values():
			if upgrade.has_method("_on_arm_shot"):
				upgrade._on_arm_shot(side, player, root)

func arm_connected(side: int, target_position: Vector2, target_body: PhysicsBody2D):
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	if side == Enums.Grapples.Left:
		for upgrade in installed_upgrades_left.values():
			if upgrade.has_method("_on_arm_connected"):
				upgrade._on_arm_connected(side, target_position, target_body, player, root)
	elif side == Enums.Grapples.Right:
		for upgrade in installed_upgrades_right.values():
			if upgrade.has_method("_on_arm_connected"):
				upgrade._on_arm_connected(side, target_position, target_body, player, root)

func arm_released(side: int):
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	if side == Enums.Grapples.Left:
		for upgrade in installed_upgrades_left.values():
			if upgrade.has_method("_on_arm_released"):
				upgrade._on_arm_released(side, player, root)
	elif side == Enums.Grapples.Right:
		for upgrade in installed_upgrades_right.values():
			if upgrade.has_method("_on_arm_released"):
				upgrade._on_arm_released(side, player, root)

func player_damaged(damage: float, damage_type: int):
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	for upgrade in installed_upgrades_left.values():
		if upgrade.has_method("_on_player_damaged"):
			upgrade._on_player_damaged(damage, damage_type, player, root)
	for upgrade in installed_upgrades_right.values():
		if upgrade.has_method("_on_player_damaged"):
			upgrade._on_player_damaged(damage, damage_type, player, root)

func player_landed():
	var player = get_tree().get_first_node_in_group("Player")
	var root = get_tree().root
	for upgrade in installed_upgrades_left.values():
		if upgrade.has_method("_on_player_landed"):
			upgrade._on_player_landed(player, root)
	for upgrade in installed_upgrades_right.values():
		if upgrade.has_method("_on_player_landed"):
			upgrade._on_player_landed(player, root)
