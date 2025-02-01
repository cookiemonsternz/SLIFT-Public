extends CharacterBody2D

@export var jump_buffer_timer: Timer
@export var Kyote: Timer

#### Grappling ####
@export_group("References")
@export var grapple_origin: Node2D
@export var rope: Line2D
@export var raycast: RayCast2D
@export var player_physics_follow: RigidBody2D

@export_group("Rotation")
@export var rotate_over_time: bool = true
@export_range(0, 60) var rotation_speed: float = 4;

@export_group("Distance")
@export var has_max_distance: bool = false
@export var max_distance: float = 1000

enum LaunchType {
	Transform_Launch,
	Physics_Launch
}

@export_group("Launching")
@export var launch_to_point: bool = true
@export var launch_type: LaunchType = LaunchType.Transform_Launch
@export var launch_speed: float = 1

@export_group("No Launch to Point")
@export var auto_configure_distance = false
@export var target_distance: float = 3
@export var target_stiffness: float = 1

var grapple_distance_vector: Vector2
var grapple_target_position: Vector2

var grapple_target: PhysicsBody2D
var spring_joint: DampedSpringJoint2D

const GRAPPLE_STRENGTH = 100

#### Player Movement ####

const JUMP_VELOCITY = -700.0 # Maximum jump strength


const gravity_strength = 3000
var light_exposure = 0
var can_kyote: bool = false
var coyote_jump_available := true
var kyote_timer_reset = true
var timer = Timer.new()

enum MoveStates {
	GROUND, 
	AIR
}

var current_move_mode = MoveStates.GROUND

func _process(delta: float) -> void:
	match current_move_mode:
		MoveStates.GROUND:
			var input_chosen = Input.get_axis("move_left", "move_right")
			var hit_jump = Input.is_action_just_pressed("player_jump")
			
			if is_on_floor():
				can_kyote = true
				kyote_timer_reset = true
			
			if can_kyote == true and velocity.y > 0 and kyote_timer_reset == true:
				Kyote.start()
				kyote_timer_reset = false
			
			if not is_on_floor() and can_kyote == true and hit_jump and Kyote.time_left > 0:
				velocity.y = JUMP_VELOCITY
			
			if not is_on_floor():
				velocity.y += gravity_strength * delta
			
			if not is_on_floor() and hit_jump:
				jump_buffer_timer.start()
			
			if is_on_floor() and jump_buffer_timer.time_left >  0:
				velocity.y = JUMP_VELOCITY
				jump_buffer_timer.stop()
			
			velocity.x = 500 * input_chosen
			if hit_jump and is_on_floor():
				can_kyote = false
				velocity.y = JUMP_VELOCITY
			
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

func handle_grapple_input():
	if Input.is_action_just_pressed("grapple_left"):
		set_grapple_target()

	elif Input.is_action_just_released("grapple_left"):
		rope.disable()
		if spring_joint != null:
			spring_joint.queue_free()
			current_move_mode = MoveStates.GROUND


# Sets the grapple target to the mouse position
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
			spring_joint = create_spring_joint(global_position, grapple_target_position, player_physics_follow, grapple_target, grapple_distance_vector.length())
			spring_joint.stiffness = launch_speed
			current_move_mode = MoveStates.AIR

func create_spring_joint(point_a: Vector2, point_b: Vector2, body_a: PhysicsBody2D, body_b: PhysicsBody2D, rest_length: float) -> DampedSpringJoint2D:
	var spring = DampedSpringJoint2D.new()
	get_tree().root.add_child(spring)
	spring.global_position = point_a
	spring.look_at(point_b)
	spring.rotation_degrees -= 90
	spring.length = rest_length#body_a.global_position.distance_to(body_b.global_position)
	spring.rest_length = rest_length
	spring.node_a = body_a.get_path()
	spring.node_b = body_b.get_path()
	return spring
