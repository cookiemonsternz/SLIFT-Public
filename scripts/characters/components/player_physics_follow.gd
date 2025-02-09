extends RigidBody2D


var set_pos_state = false
var set_vel_state = false
var move_vector = Vector2.ZERO
var vel_vector = Vector2.ZERO

func _ready():
	top_level = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if set_pos_state:
		state.transform = Transform2D(0.0, move_vector)
		set_pos_state = false
	if set_vel_state:
		state.linear_velocity = vel_vector
		set_vel_state = false

func set_pos(vector: Vector2):
	move_vector = vector
	set_pos_state = true

func set_vel(vector: Vector2):
	vel_vector = vector
	set_vel_state = true
