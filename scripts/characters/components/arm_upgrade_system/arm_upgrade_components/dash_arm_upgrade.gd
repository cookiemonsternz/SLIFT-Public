class_name DashArmUpgrade extends ArmUpgrade

var loaded_texture: Texture = preload("res://assets/Images/dash_arm_upgrade.png")

# var dashing = false
# var cached_velocity = null
# var on_arm_connected = false
# var arm_side: int = 0

# var player_cache: Player

# var stop_dash_timer : Timer

# const DASH_SPEED_MULTIPLIER = 1.8
# const DASH_TIME = 0.6
# #const DASH_MAX_DISTANCE = 800
# const DASH_MIN_SPEED = 800
# const DASH_MAX_SPEED = 2500


func _init():
	texture = loaded_texture
	upgrade_name = "DashArmUpgrade"


# Called once every process frame
func update_process(player: Player, root: Node):
	pass
	# #print(player.current_move_mode)
	# if on_arm_connected:
	# 	# Set back to ground
	# 	player.current_move_mode = Enums.MoveModes.GROUND
		
	# 	match arm_side:
	# 		0: 
	# 			if player.spring_joints[1] != null:
	# 				player.spring_joints[1].queue_free()
	# 			if player.grapple_targets[1] != null:
	# 				if player.grapple_targets[1].name == "DELETE_ME2":
	# 					player.grapple_targets[1].queue_free()
	# 				player.grapple_targets[1] = null
	# 			player.arm_upgrade_component.arm_released(Enums.Grapples.Right)
	# 		1: 
	# 			if player.spring_joints[0] != null:
	# 				player.spring_joints[0].queue_free()
	# 			if player.grapple_targets[0] != null:
	# 				if player.grapple_targets[0].name == "DELETE_ME1":
	# 					player.grapple_targets[0].queue_free()
	# 				player.grapple_targets[0] = null
	# 			player.arm_upgrade_component.arm_released(Enums.Grapples.Left)
	# 	on_arm_connected = false
	# 	dashing = true
	# if dashing and player.current_move_mode == Enums.MoveModes.GROUND:
	# 	#d print(cached_velocity.length())
	# 	#print(player.to_local(player.global_position.direction_to(player.grapple_target_positions[arm_side])).normalized().rotated(-90))
	# 	if cached_velocity.length() < DASH_MIN_SPEED:
	# 		player.velocity = DASH_MIN_SPEED * DASH_SPEED_MULTIPLIER * -(player.global_position-player.grapple_target_positions[arm_side]).normalized()
	# 	else:
	# 		if (cached_velocity.length() * DASH_SPEED_MULTIPLIER * -(player.global_position-player.grapple_target_positions[arm_side]).normalized()).length() > DASH_MAX_SPEED:
	# 			player.velocity = -(player.global_position-player.grapple_target_positions[arm_side]).normalized() * DASH_MAX_SPEED
	# 		else:
	# 			player.velocity = cached_velocity.length() * DASH_SPEED_MULTIPLIER * -(player.global_position-player.grapple_target_positions[arm_side]).normalized()
	# elif dashing and player.current_move_mode == Enums.MoveModes.AIR:
	# 	player.current_move_mode = Enums.MoveModes.AIR
	# 	player.player_physics_follow.set_vel(cached_velocity)
	# 	stop_dash()

func stop_dash():
	pass
	# print("Stopped dashing")
	# dashing = false
	# player_cache.current_move_mode = Enums.MoveModes.AIR
	# player_cache.player_physics_follow.set_vel(cached_velocity)
	# cached_velocity = null
	# on_arm_connected = false
	# stop_dash_timer.queue_free()
	# match arm_side:
	# 	0:
	# 		player_cache.rope1.disable()
	# 	1:
	# 		player_cache.rope2.disable()
	

# Called once every physics frame
# func update_physics(player: Player, root: Node):
# 	pass

# Called when an arm is shot (not when it connects)
# func _on_arm_shot(side: int, player: Player, root: Node):
# 	pass

# Called when an arm connects (e.g the spring is created)
func _on_arm_connected(side: Enums.Grapples, target_position: Vector2, _physics_body: PhysicsBody2D, player: Player, root: Node):
	player.current_move_mode = Enums.MoveModes.DASH
	# player_cache = player
	# on_arm_connected = true
	# arm_side = side
	# if player.current_move_mode == Enums.MoveModes.GROUND:
	# 	if cached_velocity == null:
	# 		cached_velocity = player.velocity
	# elif player.current_move_mode == Enums.MoveModes.AIR:
	# 	if cached_velocity == null:
	# 		cached_velocity = player.player_physics_follow.linear_velocity
	# 	player.current_move_mode = Enums.MoveModes.GROUND
	# stop_dash_timer = Timer.new()
	# stop_dash_timer.autostart = false
	# stop_dash_timer.one_shot = true
	# stop_dash_timer.wait_time = DASH_TIME
	# player.add_child(stop_dash_timer)
	# stop_dash_timer.timeout.connect(stop_dash)
	# stop_dash_timer.start()

# Called when an arm is released
# func _on_arm_released(side: int, player: Player, root: Node):
# 	pass

# Called when the player recieves damage
# func _on_player_damaged(damage: float, damage_type: int, player: Player, root: Node):
# 	pass

# Called when the player lands
# func _on_player_landed(player: Player, root: Node):
# 	pass
