class_name DashArmUpgrade extends ArmUpgrade

var loaded_texture: Texture = preload("res://assets/Images/dash_arm_upgrade.png")


var arm_side: int = 0
var dash_target: Vector2

var stop_dash_timer : Timer


const DASH_TIME = 0.6
const DASH_SPEED = 450
const DASH_MULTIPLIER = 2

func _init():
	texture = loaded_texture
	upgrade_name = "DashArmUpgrade"


# Called once every process frame
#func update_process(player: Player, _root: Node):
	#pass

func update_physics(player: Player, _root: Node):
	if player.current_move_mode == Enums.MoveModes.DASH:
		# Bit long, but better safe than sorry
		if player.global_position.distance_to(dash_target) < 100:
			stop_dash(player)
		
		player.velocity = dash_target - player.global_position
		# If we are above the max speed, override the max speed to be the players current speed.
		if (player.velocity.length() > DASH_SPEED and player.current_move_mode == Enums.MoveModes.GROUND) or (player.player_physics_follow.linear_velocity.length() > DASH_SPEED and player.current_move_mode == Enums.MoveModes.AIR):
			player.velocity = sqrt(max(player.velocity.length_squared(), player.player_physics_follow.linear_velocity.length_squared())) * player.velocity.normalized()
		else:
			player.velocity = player.velocity.normalized() * DASH_SPEED
		player.velocity *= DASH_MULTIPLIER
		player.move_and_slide()
		player.velocity /= DASH_MULTIPLIER

func stop_dash(player: Player):
	player.current_move_mode = Enums.MoveModes.AIR
	player.velocity = Vector2.ZERO
	player.set_collision_layer_value(4, true) # PLAYER LAYER
	player.set_collision_layer_value(9, false) # DASHING PLAYER LAYER
	# we should cache the init collision mask instead, if we change it in editor, this will break it and be hard to track down.
	player.collision_mask = 0b010101111


# Called when an arm connects (e.g the spring is created)
func _on_arm_connected(side: Enums.Grapples, target_position: Vector2, _physics_body: PhysicsBody2D, player: Player, _root: Node):
	player.current_move_mode = Enums.MoveModes.DASH

	player.set_collision_layer_value(4, false) # PLAYER LAYER
	player.set_collision_layer_value(9, true) # DASHING PLAYER LAYER
	# Collision Mask
	# We want to collide with - Doors, lights, player, enemies, but not physics follow, platforms or rigid bodies
	# 1 - Platforms, 2 - RB's, 3 - Lights, 4 - Player, 5 - Buttons, 6 - Doors, 7 - Physics Follow, 8 - Enemies, 9 - Dashing Player
	# End bit is 1, so last bit should be off bc platforms should not collide
	player.collision_mask = 0b000111100

	# Timer to stop the dash
	stop_dash_timer = Timer.new()
	stop_dash_timer.autostart = false
	stop_dash_timer.one_shot = true
	stop_dash_timer.wait_time = DASH_TIME
	player.add_child(stop_dash_timer)
	stop_dash_timer.timeout.connect(stop_dash.bind(player))
	stop_dash_timer.start()

	# Cache the side and target position for access in the process function - TODO add side to the process callback
	arm_side = side
	dash_target = target_position
