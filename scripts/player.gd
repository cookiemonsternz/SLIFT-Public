extends CharacterBody2D

#### Grappling ####
@export_group("Grappling")

@export_subgroup("References")
@export var grapple_origin: Node2D
@export var rope: Line2D
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

var grapple_distance_vector: Vector2
var grapple_target_position: Vector2

# The target body which the grapple connects to
var grapple_target: PhysicsBody2D
# Normally null, init a new one when we need it
# Need to refactor this if we want multiple grapples (l/r)
var spring_joint: DampedSpringJoint2D


#### Player Movement ####
@export_group("Player Movement")

@export_subgroup("References")
@export var jump_buffer_timer: Timer
@export var coyote_time_timer: Timer

@export_subgroup("Jumping")
@export var jump_velocity = -700.0 # Maximum jump strength
@export var gravity_strength = 3000.0 # Gravity strength
@export var jump_buffer_time = 0.1 # Time in seconds to buffer a jump

@export_subgroup("Movement")
@export var move_speed = 500.0 # Movement speed
@export var coyote_time_time = 0.1 # Time in seconds to allow a coyote jump


var can_coyote: bool = false
var coyote_jump_available := true
var coyote_timer_reset := true

var light_exposure = 0

var current_move_mode = MoveStates.GROUND

enum MoveStates {
	GROUND, 
	AIR
}

# Set the timer duration based on the export vars
func _ready() -> void:
	coyote_time_timer.wait_time = coyote_time_time
	jump_buffer_timer.wait_time = jump_buffer_time

func _process(delta: float) -> void:
	match current_move_mode:
		MoveStates.GROUND:
			var input_chosen = Input.get_axis("move_left", "move_right")
			var hit_jump = Input.is_action_just_pressed("player_jump")
			var is_on_floor = is_on_floor()
			
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
				can_coyote = false
				velocity.y = jump_velocity
			
			velocity.x += move_speed * input_chosen
			
			velocity *= 0.99
			
			move_and_slide()
		MoveStates.AIR:
			global_position = player_physics_follow.global_position
	
func _physics_process(_delta: float) -> void:
	handle_grapple_input()
	match current_move_mode:
		MoveStates.GROUND:
			player_physics_follow.set_pos(global_position)
			player_physics_follow.set_vel(velocity)
		MoveStates.AIR:
			pass
			#if spring_joint != null and spring_joint.length >= 30:
				#print(spring_joint.length)
				#spring_joint.length -= 5
				#spring_joint.rest_length -= 5

func handle_grapple_input():
	if Input.is_action_just_pressed("grapple_left"):
		set_grapple_target()

	elif Input.is_action_just_released("grapple_left"):
		rope.disable()
		if spring_joint != null:
			spring_joint.queue_free()
			current_move_mode = MoveStates.GROUND
			velocity = player_physics_follow.linear_velocity


# Gets the body to connect to, and sets the grapple_target_position
func set_grapple_target() -> void:
	var distance_vector = get_global_mouse_position() - global_position
	raycast.target_position = to_local(distance_vector * 100)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		if raycast.get_collision_point().distance_to(global_position) <= max_distance or not has_max_distance:
			grapple_target_position = raycast.get_collision_point()
			grapple_distance_vector = grapple_target_position - global_position
			grapple_target = raycast.get_collider()
			rope.enable()

# Creates a spring joint between the player and the grapple target
func grapple() -> void:
	match (launch_type):
		LaunchType.Physics_Launch:
			spring_joint = create_spring_joint(global_position, grapple_target_position, player_physics_follow, grapple_target, grapple_distance_vector.length() - rest_distance)
			current_move_mode = MoveStates.AIR

func create_spring_joint(point_a: Vector2, point_b: Vector2, body_a: PhysicsBody2D, body_b: PhysicsBody2D, rest_length: float) -> DampedSpringJoint2D:
	print("Making spring joint")
	var spring = DampedSpringJoint2D.new()
	
	spring.length = grapple_distance_vector.length()
	spring.rest_length = max(rest_length, 30)
	
	spring.stiffness = launch_speed
	
	spring.damping = damping
	
	spring.bias = bias
	
	spring.global_position = point_a
	spring.look_at(point_b)
	spring.rotation_degrees -= 90
	
	spring.node_a = body_a.get_path()
	spring.node_b = body_b.get_path()
	
	get_tree().root.add_child(spring)
	
	return spring
