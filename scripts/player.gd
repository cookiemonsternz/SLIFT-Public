extends CharacterBody2D

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
@export var player: CharacterBody2D

@export_subgroup("Jumping")
@export var jump_velocity = -700.0 # Maximum jump strength
@export var gravity_strength = 3000.0 # Gravity strength
@export var jump_buffer_time = 0.1 # Time in seconds to buffer a jump

@export_subgroup("Movement")
@export var move_speed = 500.0 # Movement speed
@export var coyote_time_time = 0.1 # Time in seconds to allow a coyote jump
@export var velocity_timer: Timer 
@export var slow_speed = 800
@export var mantain_speed = 0
@export var stop_speed = 1600

@export_group("")
@export var health_component: Node
@export var do_delete_timer: Timer


var can_coyote: bool = false
var coyote_jump_available := true
var coyote_timer_reset := true
var velocity_track = true
var velocity_apply = false
var velocity_slide_change = true
var velocity_add = 0
var move_mode_two = false
var velocity_can_change = true
var velocity_new = null
var light_exposure = 0
var barrier = false
var current_move_mode = MoveStates.GROUND
var craig = true
var ruckus = 0
var slow_down = false
enum MoveStates {
	GROUND, 
	AIR
}








# Set the timer duration based on the export vars
func _ready() -> void:
	coyote_time_timer.wait_time = coyote_time_time
	jump_buffer_timer.wait_time = jump_buffer_time

func _process(delta: float) -> void:
	print(move_mode_two)
	print(ruckus)
	var velocity_add = player_physics_follow.linear_velocity.x
	match current_move_mode:
		MoveStates.GROUND:
			var input_chosen = Input.get_axis("move_left", "move_right")
			var hit_jump = Input.is_action_just_pressed("player_jump")
			var is_on_floor = is_on_floor()
			#
			#if is_on_floor and velocity_track == false:
				##print(velocity.x)
				#if input_chosen == -1:
					#velocity.x = $".".velocity.x * input_chosen * -1
				#if input_chosen == 1:
					#velocity.x = $".".velocity.x * input_chosen 
				#move_and_slide()
			
			if light_exposure >= 20:
				modulate = Color(1.0, 0.0, 0.0)
			
			if is_on_floor() and barrier == true and move_mode_two == true:
				player.velocity.x = ruckus
				slow_down = true
				
			if is_on_floor and slow_down == true and move_mode_two == true:
				if ruckus > -25 and ruckus < 25:
					craig = false
					barrier = false
					ruckus = 0
					move_mode_two = false
				if ruckus > 0 and craig == true and input_chosen < 0:
					ruckus -= stop_speed * delta
					slow_down = false
				if ruckus > 0 and craig == true and input_chosen == 0:
					ruckus -= slow_speed * delta
					slow_down = false
				if ruckus > 0 and craig == true and input_chosen > 0:
					ruckus -= mantain_speed * delta
					slow_down = false
				
				if ruckus < 0 and craig == true and input_chosen > 0:
					ruckus += stop_speed * delta
					slow_down = false
				if ruckus < 0 and craig == true and input_chosen < 0:
					ruckus += mantain_speed * delta
					slow_down = false
				if ruckus < 0 and craig == true and input_chosen == 0:
					ruckus += slow_speed * delta
					slow_down = false
				
			
			
			if is_on_floor:
				
				can_coyote = true
				coyote_timer_reset = true
			
			if can_coyote and velocity.y > 0 and coyote_timer_reset:
				coyote_time_timer.start()
				coyote_timer_reset = false
			
			if not is_on_floor and can_coyote and hit_jump and coyote_time_timer.time_left > 0:
				velocity.y = jump_velocity
			
			if not is_on_floor:
				velocity.y += gravity_strength * delta
			
			if not is_on_floor and hit_jump:
				jump_buffer_timer.start()
			
			if is_on_floor and jump_buffer_timer.time_left >  0:
				velocity.y = jump_velocity
				jump_buffer_timer.stop()
			
			if hit_jump and is_on_floor:
				craig = false
				barrier = false
				ruckus = 0
				move_mode_two = false
				can_coyote = false
				velocity.y = jump_velocity
			
			if is_on_floor() and velocity_apply == true:
				move_mode_two = true
				
			if not barrier:
				velocity.x = move_speed * input_chosen 
			
			velocity *= 0.99
			
			move_and_slide()
		MoveStates.AIR:
			if not ground_cast.is_colliding():
				barrier = false
			velocity_add = player_physics_follow.linear_velocity.x
			if ground_cast.is_colliding() and do_delete_timer.is_stopped():
				if barrier == false:
					ruckus = velocity_add
					barrier = true
				current_move_mode = MoveStates.GROUND
				velocity_timer.start()
				velocity_can_change = false
				if spring_joints[1] != null:
					spring_joints[1].queue_free()
					rope2.disable()
				if spring_joints[0] != null:
					spring_joints[0].queue_free()
					rope1.disable()
			
			global_position = player_physics_follow.global_position
	
func _physics_process(_delta: float) -> void:
	handle_grapple_input()
	match current_move_mode:
		MoveStates.GROUND:
			player_physics_follow.set_pos(global_position)
			player_physics_follow.set_vel(velocity)
			#print(velocity.x)
		MoveStates.AIR:
			velocity_apply = false
			craig = true
			move_mode_two = true
			#if not Input.is_action_pressed("grapple_left") and not Input.is_action_pressed("grapple_right"):
				#current_move_mode = MoveStates.GROUND
				#velocity = player_physics_follow.linear_velocity
			#if spring_joint != null and spring_joint.length >= 30:
				#print(spring_joint.length)
				#spring_joint.length -= 5
				#spring_joint.rest_length -= 5

func handle_grapple_input():
	if Input.is_action_just_pressed("grapple_left"):
		set_grapple_target(Grapples.Left)
	elif Input.is_action_just_released("grapple_left"):
		rope1.disable()
		if spring_joints[0] != null:
			spring_joints[0].queue_free()
	
	if Input.is_action_just_pressed("grapple_right"):
		set_grapple_target(Grapples.Right)
	elif Input.is_action_just_released("grapple_right"):
		rope2.disable()
		if spring_joints[1] != null:
			spring_joints[1].queue_free()


# Gets the body to connect to, and sets the grapple_target_position
func set_grapple_target(side: int) -> void:
	var direction_vector = get_global_mouse_position() - global_position
	raycast.target_position = to_local(direction_vector * 100)
	
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		if raycast.get_collision_point().distance_to(global_position) <= max_distance or not has_max_distance:
			match side:
				Grapples.Left:
					grapple_target_positions[0] = raycast.get_collision_point()
					grapple_distance_vectors[0] = grapple_target_positions[0] - global_position
					grapple_targets[0] = raycast.get_collider()
					rope1.enable()
				Grapples.Right:
					grapple_target_positions[1] = raycast.get_collision_point()
					grapple_distance_vectors[1] = grapple_target_positions[1] - global_position
					grapple_targets[1] = raycast.get_collider()
					rope2.enable()

# Creates a spring joint between the player and the grapple target
func grapple(side: int) -> void:
	match (launch_type):
		LaunchType.Physics_Launch:
			do_delete_timer.start()
			match side:
				Grapples.Left:
					spring_joints[0] = create_spring_joint(global_position, grapple_target_positions[0], player_physics_follow, grapple_targets[0], grapple_distance_vectors[0].length(), grapple_distance_vectors[0].length() - rest_distance)
					#if spring_joints[1] != null:
						#spring_joints[1].rest_length = grapple_distance_vectors[0].length() - rest_distance
				Grapples.Right:
					spring_joints[1] = create_spring_joint(global_position, grapple_target_positions[1], player_physics_follow, grapple_targets[1], grapple_distance_vectors[1].length(), grapple_distance_vectors[1].length() - rest_distance)
					#if spring_joints[0] != null:
						#spring_joints[0].rest_length = grapple_distance_vectors[1].length() - rest_distance
			current_move_mode = MoveStates.AIR

func create_spring_joint(point_a: Vector2, point_b: Vector2, body_a: PhysicsBody2D, body_b: PhysicsBody2D, length: float, rest_length: float) -> DampedSpringJoint2D:
	
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


func _on_velocity_timer_timeout() -> void:
	var velocity_new = velocity_add
	print("Test")
