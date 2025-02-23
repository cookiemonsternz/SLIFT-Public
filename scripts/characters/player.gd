class_name Player extends CharacterBody2D

#### Grappling ####
@export_group("Grappling")

@export_subgroup("References")
@export var grapple_origin: Node2D
@export var rope1: Line2D
@export var rope2: Line2D
@export var raycast: RayCast2D
@export var player_physics_follow: RigidBody2D 
@export var do_delete_timer: Timer


@export_subgroup("")
@export var max_distance: float = 1000
@export var launch_type: Enums.LaunchType = Enums.LaunchType.Transform_Launch

var grapple_distance_vectors: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
var grapple_target_positions: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]

# The target body which the grapple connects to
var grapple_targets: Array[PhysicsBody2D] = [null, null]
var grapple_target_markers: Array[Node2D] = [null, null]

#### Player Movement ####
@export_group("Player Movement")

@export_subgroup("References")
@export var jump_buffer_timer: Timer
@export var coyote_time_timer: Timer
@export var ground_casts: Node2D
@export var death_screen: Control
@export var win_screen: Control
@export var win_button: Button

@export_subgroup("Jumping")
@export var jump_velocity = -700.0 # Maximum jump strength
@export var gravity_strength = 2000 # Gravity strength
@export var jump_buffer_time = 0.1 # Time in seconds to buffer a jump

@export_subgroup("Movement")
@export var move_speed = 500.0 # Movement speed
@export var coyote_time_time = 0.1 # Time in seconds to allow a coyote jump
@export var slow_speed = 800
@export var mantain_speed = 0
@export var stop_speed = 1600

@export_group("Components")
@export var health_component: HealthComponent
@export var arm_upgrade_component: ArmUpgradeComponent

var is_dead = false
var can_coyote: bool = false
var coyote_timer_reset := true
var current_move_mode := Enums.MoveModes.GROUND
var is_sliding := false
var vel_x: float = 0


# Set the timer duration based on the export vars
func _ready() -> void:
	coyote_time_timer.wait_time = coyote_time_time
	jump_buffer_timer.wait_time = jump_buffer_time
	var callable = func(damage: float, damage_type: Enums.DamageType, damage_source: Node):
		printerr("Player died, last damage : ", damage, ", damage type : ", damage_type, ", damage source : ", damage_source)
		modulate = Color(1.0, 0.0, 0.0)
	health_component.entity_died.connect(callable)

	# Basic grapple upgrades
	var grapple_upgrade = GrappleArmUpgrade.new()
	arm_upgrade_component.add_upgrade(Enums.Grapples.Left, 0, grapple_upgrade)
	var grapple_upgrade2 = GrappleArmUpgrade.new()
	arm_upgrade_component.add_upgrade(Enums.Grapples.Right, 0, grapple_upgrade2)

func _process(delta: float) -> void:

	if death_screen.visible == true:
		move_speed = 0
		jump_velocity = 0
		is_dead = true

	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	#print(position)

	if Input.is_action_just_pressed("test_input"):
		arm_upgrade_component.remove_upgrade(Enums.Grapples.Left, 0)
		var dash_upgrade = DashArmUpgrade.new()
		arm_upgrade_component.add_upgrade(Enums.Grapples.Left, 0, dash_upgrade)
		#var yank_upgrade = YankArmUpgrade.new()
		#arm_upgrade_component.add_upgrade(Enums.Grapples.Left, 0, yank_upgrade)
		#tiivar damage_upgrade = DamageArmUpgrade.new()
		#arm_upgrade_component.add_upgrade(Enums.Grapples.Right, 0, damage_upgrade)

	match current_move_mode:
		Enums.MoveModes.GROUND:
			arm_upgrade_component._on_process(delta)
		Enums.MoveModes.AIR:
			handle_air_movement()
			arm_upgrade_component._on_process(delta)
		Enums.MoveModes.DASH:
			arm_upgrade_component._on_process(delta)

func _physics_process(delta: float) -> void:
	arm_upgrade_component._on_physics_process(delta)
	handle_grapple_input()
	match current_move_mode:
		Enums.MoveModes.GROUND:
			# Make sure the physics follow snaps to player position
			# Use these functions instead of overriding position directly bc
			# position propertie is effectively read only (eg will cause desync with physics server if written)
			player_physics_follow.set_pos(global_position)
			player_physics_follow.set_vel(velocity)

			handle_ground_movement(delta)
			move_and_slide()
		Enums.MoveModes.AIR:
			pass
			# If the player is in the air and the player is not moving and the arms are not connected
			# we move the player down a bit to make sure the player doesn't get stuck in roofs
			# also stops bouncing after hitting head for some reason
			# if spring_joints[0] == null and spring_joints[1] == null and player_physics_follow.linear_velocity.x == 0 and player_physics_follow.linear_velocity.y == 0:
			# 	player_physics_follow.set_pos(Vector2(player_physics_follow.global_position.x, player_physics_follow.global_position.y - 1))
		Enums.MoveModes.DASH:
			player_physics_follow.set_pos(global_position)
			player_physics_follow.set_vel(velocity)

func handle_ground_movement(delta: float):
	var input_chosen = Input.get_axis("move_left", "move_right")
	var hit_jump = Input.is_action_just_pressed("player_jump")
	var on_floor = is_on_floor()
		
	if can_coyote and velocity.y > 0 and coyote_timer_reset:
		coyote_time_timer.start()
		coyote_timer_reset = false
	
	if not on_floor and can_coyote and hit_jump and coyote_time_timer.time_left > 0:
		velocity.y = jump_velocity
	
	if not on_floor and hit_jump:
		jump_buffer_timer.start()
	
	if on_floor and jump_buffer_timer.time_left >  0:
		velocity.y = jump_velocity
		jump_buffer_timer.stop()
	
	if hit_jump and on_floor:
		is_sliding = false
		can_coyote = false
		velocity.y = jump_velocity
	
	if on_floor:
		can_coyote = true
		coyote_timer_reset = true
	
	else:
		velocity.y += gravity_strength * delta
	
	if is_sliding:
		handle_sliding(input_chosen, delta)
		velocity.x = vel_x
	elif abs(velocity.x) <= move_speed:
		velocity.x = move_speed * input_chosen
	else:
		velocity.x = abs(velocity.x) * input_chosen

func handle_sliding(input_chosen: float, delta: float):
	# If we have low velocity change back to regular move mode
	if vel_x > -25 and vel_x < 25:
		is_sliding = false
		vel_x = 0
	
	# Case for sliding right when holding left
	if vel_x > 0 and input_chosen < 0:
		vel_x -= stop_speed * delta
	# Case for sliding right when holding nothing
	if vel_x > 0 and input_chosen == 0:
		vel_x -= slow_speed * delta
	# Case for sliding left when holding right
	if vel_x > 0 and input_chosen > 0:
		vel_x -= mantain_speed * delta
	# Case for sliding left when holding right
	if vel_x < 0 and input_chosen > 0:
		vel_x += stop_speed * delta
	# Case for sliding left when holding left
	if vel_x < 0 and input_chosen < 0:
		vel_x += mantain_speed * delta
	# Case for sliding right when holding nothing
	if vel_x < 0 and input_chosen == 0:
		vel_x += slow_speed * delta

func handle_air_movement():
	# Set position to the rigidbody position
	# global_position = player_physics_follow.global_position

	if not ground_is_colliding():
		is_sliding = false

	# If the player is on the ground and the timer that starts when player leaves ground is stopped (eg the timer has runout)
	# we delete the arms and set the player to the ground state
	if ground_is_colliding() and do_delete_timer.is_stopped():	
		arm_upgrade_component.player_landed()
		if not is_sliding:
			vel_x = player_physics_follow.linear_velocity.x
			is_sliding = true
		
		# Delete arms and disable ropes
		if rope2.enabled:
			rope2.disable()
		
		if rope1.enabled:
			rope1.disable()
		
		current_move_mode = Enums.MoveModes.GROUND

func handle_grapple_input():
	if Input.is_action_just_pressed("grapple_left"):
		set_grapple_target(Enums.Grapples.Left)
		arm_upgrade_component.arm_shot(Enums.Grapples.Left)
	elif Input.is_action_just_released("grapple_left"):
		rope1.disable()
		# if spring_joints[0] != null:
		# 	spring_joints[0].queue_free()
		if grapple_targets[0] != null:
			# This case is for the temporary static body that is spawned when shooting at tilemaps
			# As tilemaps are not physics body's we need to create one to attach the spring to, but after 
			# it needs to be deleted.
			if grapple_targets[0].name == "DELETE_ME1":
				grapple_targets[0].queue_free()
			grapple_targets[0] = null
		if grapple_target_markers[0] != null:
			grapple_target_markers[0].queue_free()
			grapple_target_markers[0] = null
		arm_upgrade_component.arm_released(Enums.Grapples.Left)
	
	# etc. etc.
	if Input.is_action_just_pressed("grapple_right"):
		set_grapple_target(Enums.Grapples.Right)
		arm_upgrade_component.arm_shot(Enums.Grapples.Right)
	elif Input.is_action_just_released("grapple_right"):
		rope2.disable()
		# if spring_joints[1] != null:
		# 	spring_joints[1].queue_free()
		if grapple_targets[1] != null:
			if grapple_targets[1].name == "DELETE_ME2":
				grapple_targets[1].queue_free()
			grapple_targets[1] = null
		if grapple_target_markers[1] != null:
			grapple_target_markers[1].queue_free()
			grapple_target_markers[1] = null
		arm_upgrade_component.arm_released(Enums.Grapples.Right)


# Gets the body to connect to, and sets the grapple_target_position
func set_grapple_target(side: int) -> void:
	var direction_vector = get_local_mouse_position()
	raycast.target_position = (direction_vector.normalized() * 5000)
	
	# Need to force a raycast update
	# otherwise collisions won't happen until next frame
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		# check that we are within the max distance
		if raycast.get_collision_point().distance_to(global_position) <= max_distance:
			match side:
				Enums.Grapples.Left:
					grapple_target_positions[0] = raycast.get_collision_point()
					grapple_distance_vectors[0] = grapple_target_positions[0] - global_position

					# If its a tilemap spawn the temp static body for the spring target
					if raycast.get_collider() is TileMapLayer:
						var temp_static_body = StaticBody2D.new()

						temp_static_body.global_position = grapple_target_positions[0]
						temp_static_body.name = "DELETE_ME1"

						get_tree().root.add_child(temp_static_body)

						grapple_targets[0] = temp_static_body

						var temp_marker = Node2D.new()
						temp_marker.name = "DELETE_ME1"
						grapple_targets[0].add_child(temp_marker)
						grapple_target_markers[0] = temp_marker
						temp_marker.global_position = grapple_target_positions[0]
					else:
						# Otherwise just use the colliding physics body
						grapple_targets[0] = raycast.get_collider()
						var temp_marker = Node2D.new()
						temp_marker.name = "DELETE_ME1"
						grapple_targets[0].add_child(temp_marker)
						grapple_target_markers[0] = temp_marker
						temp_marker.global_position = grapple_target_positions[0]
					
					rope1.enable()
				Enums.Grapples.Right:
					grapple_target_positions[1] = raycast.get_collision_point()
					grapple_distance_vectors[1] = grapple_target_positions[1] - global_position
					
					if raycast.get_collider() is TileMapLayer:
						var temp_static_body = StaticBody2D.new()

						temp_static_body.global_position = grapple_target_positions[1]
						temp_static_body.name = "DELETE_ME2"

						get_tree().root.add_child(temp_static_body)
						grapple_targets[1] = temp_static_body
						var temp_marker = Node2D.new()
						temp_marker.name = "DELETE_ME2"
						grapple_targets[1].add_child(temp_marker)
						grapple_target_markers[1] = temp_marker
						temp_marker.global_position = grapple_target_positions[1]
					else:
						grapple_targets[1] = raycast.get_collider()
						var temp_marker = Node2D.new()
						temp_marker.name = "DELETE_ME2"
						grapple_targets[1].add_child(temp_marker)
						grapple_target_markers[1] = temp_marker
						temp_marker.global_position = grapple_target_positions[1]
					
					rope2.enable()

# Creates a spring joint between the player and the grapple target
func grapple(side: int) -> void:
	match (launch_type):
		# Other launch type not yet implemented, maybe arm upgrade?
		Enums.LaunchType.Physics_Launch:
			# Do delete timer is used to delete arms if the player is still on the ground when the timer runs out.
			do_delete_timer.start()

			match side:
				Enums.Grapples.Left:
					arm_upgrade_component.arm_connected(Enums.Grapples.Left, grapple_target_positions[0], grapple_targets[0])
				Enums.Grapples.Right:
					arm_upgrade_component.arm_connected(Enums.Grapples.Right, grapple_target_positions[1], grapple_targets[1])


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func ground_is_colliding() -> bool:
	var n_colliding = 0
	for i: RayCast2D in ground_casts.get_children():
		if i.is_colliding():
			n_colliding += 1;
			if n_colliding > 1:
				return true
	return false
