class_name Player extends CharacterBody2D

#### Grappling ####
@export_group("Grappling")

@export_subgroup("References")
@export var grapple_origin: Node2D
@export var rope1: Line2D
@export var rope2: Line2D
@export var raycast: RayCast2D
@export var player_physics_follow: RigidBody2D 


@export_subgroup("Distance")
@export var has_max_distance: bool = false
@export var max_distance: float = 1000
@export var rest_distance: float = 250

@export_subgroup("Launching")
@export var launch_type: LaunchType = LaunchType.Transform_Launch
@export var launch_speed: float = 1
@export var damping: float = 1
@export var bias: float = 0

enum LaunchType {
	Transform_Launch,
	Physics_Launch
}

enum Grapples {
	Left,
	Right
}

var grapple_distance_vectors: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
var grapple_target_positions: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]

# The target body which the grapple connects to
var grapple_targets: Array[PhysicsBody2D] = [null, null]
# Normally null, init a new one when we need it
# Need to refactor this if we want multiple grapples (l/r)
var spring_joints: Array[DampedSpringJoint2D] = [null, null]

#### Player Movement ####
@export_group("Player Movement")

@export_subgroup("References")
@export var jump_buffer_timer: Timer
@export var coyote_time_timer: Timer
@export var ground_cast: RayCast2D

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

@export_group("")
@export var health_component: Node
@export var arm_upgrade_component: ArmUpgradeComponent
@export var do_delete_timer: Timer


var can_coyote: bool = false
var coyote_jump_available := true
var coyote_timer_reset := true
var current_move_mode := MoveModes.GROUND
var is_sliding := false
var can_var_jump := true
var vel_x: float = 0
enum MoveModes {
	GROUND, 
	AIR
}

# Set the timer duration based on the export vars
func _ready() -> void:
	coyote_time_timer.wait_time = coyote_time_time
	jump_buffer_timer.wait_time = jump_buffer_time

func _process(delta: float) -> void:
	#print(position)
	if Input.is_action_just_pressed("test_input"):
		var yank_upgrade = YankArmUpgrade.new()
		arm_upgrade_component.add_upgrade(Grapples.Left, 0, yank_upgrade)
	match current_move_mode:
		MoveModes.GROUND:
			handle_ground_movement(delta)
		MoveModes.AIR:
			handle_air_movement()
			

func handle_ground_movement(delta: float):
	var input_chosen = Input.get_axis("move_left", "move_right")
	var hit_jump = Input.is_action_just_pressed("player_jump")
	var holding_jump = Input.is_action_pressed("player_jump")
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
		can_var_jump = true
		can_coyote = true
		coyote_timer_reset = true
	
	else:
		#if holding_jump and can_var_jump and not is_sliding:
			#velocity.y += gravity_strength * delta  * 0.75
		#else:
			#if Input.is_action_just_released("jump") and can_var_jump and not is_sliding:
			#	velocity.y = 0
			#	can_var_jump = false
		velocity.y += gravity_strength * delta
	
	#print(velocity)
	
	if is_sliding:
		handle_sliding(input_chosen, delta)
		velocity.x = vel_x
	elif abs(velocity.x) <= move_speed:
		velocity.x = move_speed * input_chosen
	else:
		velocity.x = abs(velocity.x) * input_chosen

	move_and_slide()

func handle_sliding(input_chosen: float, delta: float):
	# If we have low velocity change back to regular move mode
	if vel_x > -15 and vel_x < 15:
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
	global_position = player_physics_follow.global_position

	if not ground_cast.is_colliding():
		is_sliding = false

	# If the player is on the ground and the timer that starts when player leaves ground is stopped (eg the timer has runout)
	# we delete the arms and set the player to the ground state
	if ground_cast.is_colliding() and do_delete_timer.is_stopped():	
		arm_upgrade_component.player_landed()
		if not is_sliding:
			vel_x = player_physics_follow.linear_velocity.x
			is_sliding = true
		
		
		if spring_joints[1] != null:
			spring_joints[1].queue_free()
			rope2.disable()
		
		if spring_joints[0] != null:
			spring_joints[0].queue_free()
			rope1.disable()
		
		current_move_mode = MoveModes.GROUND

func _physics_process(_delta: float) -> void:
	handle_grapple_input()
	match current_move_mode:
		MoveModes.GROUND:
			player_physics_follow.set_pos(global_position)
			player_physics_follow.set_vel(velocity)
		MoveModes.AIR:
			if spring_joints[0] == null and spring_joints[1] == null and player_physics_follow.linear_velocity.x == 0 and player_physics_follow.linear_velocity.y == 0:
				player_physics_follow.set_pos(Vector2(player_physics_follow.global_position.x, player_physics_follow.global_position.y - 1))

func handle_grapple_input():
	if Input.is_action_just_pressed("grapple_left"):
		set_grapple_target(Grapples.Left)
		arm_upgrade_component.arm_shot(Grapples.Left)
	elif Input.is_action_just_released("grapple_left"):
		rope1.disable()
		if spring_joints[0] != null:
			spring_joints[0].queue_free()
		if grapple_targets[0] != null:
			if grapple_targets[0].name == "DELETE_ME1":
				grapple_targets[0].queue_free()
			grapple_targets[0] = null
		arm_upgrade_component.arm_released(Grapples.Left)
	
	if Input.is_action_just_pressed("grapple_right"):
		set_grapple_target(Grapples.Right)
		arm_upgrade_component.arm_shot(Grapples.Right)
	elif Input.is_action_just_released("grapple_right"):
		rope2.disable()
		if spring_joints[1] != null:
			spring_joints[1].queue_free()
		if grapple_targets[1] != null:
			if grapple_targets[1].name == "DELETE_ME2":
				grapple_targets[1].queue_free()
			grapple_targets[1] = null
		arm_upgrade_component.arm_released(Grapples.Right)


# Gets the body to connect to, and sets the grapple_target_position
func set_grapple_target(side: int) -> void:
	var direction_vector = get_local_mouse_position()# - player_physics_follow.global_position
	raycast.target_position = (direction_vector.normalized() * 5000)
	
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		if raycast.get_collision_point().distance_to(global_position) <= max_distance or not has_max_distance:
			#print(grapple_targets)
			match side:
				Grapples.Left:
					grapple_target_positions[0] = raycast.get_collision_point()
					grapple_distance_vectors[0] = grapple_target_positions[0] - global_position
					if raycast.get_collider() is TileMapLayer:
						var temp_static_body = StaticBody2D.new()
						temp_static_body.global_position = grapple_target_positions[0]
						temp_static_body.name = "DELETE_ME1"
						get_tree().root.add_child(temp_static_body)
						grapple_targets[0] = temp_static_body
					else:
						grapple_targets[0] = raycast.get_collider()
					rope1.enable()
				Grapples.Right:
					grapple_target_positions[1] = raycast.get_collision_point()
					grapple_distance_vectors[1] = grapple_target_positions[1] - global_position
					if raycast.get_collider() is TileMapLayer:
						var temp_static_body = StaticBody2D.new()
						temp_static_body.global_position = grapple_target_positions[1]
						temp_static_body.name = "DELETE_ME2"
						get_tree().root.add_child(temp_static_body)
						grapple_targets[1] = temp_static_body
					else:
						grapple_targets[1] = raycast.get_collider()
					rope2.enable()

# Creates a spring joint between the player and the grapple target
func grapple(side: int) -> void:
	match (launch_type):
		LaunchType.Physics_Launch:
			do_delete_timer.start()
			current_move_mode = MoveModes.AIR
			match side:
				Grapples.Left:
					spring_joints[0] = create_spring_joint(global_position, grapple_target_positions[0], player_physics_follow, grapple_targets[0], grapple_distance_vectors[0].length(), grapple_distance_vectors[0].length() - rest_distance)
					arm_upgrade_component.arm_connected(Grapples.Left, grapple_target_positions[0])
					#if spring_joints[1] != null:
						#spring_joints[1].rest_length = grapple_distance_vectors[0].length() - rest_distance
				Grapples.Right:
					spring_joints[1] = create_spring_joint(global_position, grapple_target_positions[1], player_physics_follow, grapple_targets[1], grapple_distance_vectors[1].length(), grapple_distance_vectors[1].length() - rest_distance)
					arm_upgrade_component.arm_connected(Grapples.Right, grapple_target_positions[1])
					#if spring_joints[0] != null:
						#spring_joints[0].rest_length = grapple_distance_vectors[1].length() - rest_distance
			

func create_spring_joint(point_a: Vector2, point_b: Vector2, body_a: PhysicsBody2D, body_b: PhysicsBody2D, length: float, rest_length: float) -> DampedSpringJoint2D:
	if body_a == null or body_b == null:
		return DampedSpringJoint2D.new()
	var spring = DampedSpringJoint2D.new()
	
	spring.length = length
	spring.rest_length = max(rest_length, 30)
	
	spring.stiffness = launch_speed
	
	spring.damping = damping
	
	spring.bias = bias
	
	spring.disable_collision = false
	
	spring.global_position = point_a
	spring.look_at(point_b)
	spring.rotation_degrees -= 90
	
	spring.node_a = body_a.get_path()
	spring.node_b = body_b.get_path()
	
	get_tree().root.add_child(spring)
	
	return spring
