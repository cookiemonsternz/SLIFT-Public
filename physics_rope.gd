extends Node2D

@export var rope_thickness = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_input"):
		#create_static_body(get_global_mouse_position())
		create_rope(get_global_mouse_position(), Vector2(866, 477), create_static_body(get_global_mouse_position()), $StaticBody2D, 15)


func create_static_body(body_position: Vector2):
	var static_body = StaticBody2D.new()
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 50
	collision_shape.shape = shape
	static_body.add_child(collision_shape)
	static_body.global_position = body_position
	add_child(static_body)
	return static_body

func create_pin_joint(joint_body_a: PhysicsBody2D, joint_body_b: PhysicsBody2D, joint_position: Vector2):
	var pin_joint := PinJoint2D.new()
	pin_joint.global_position = joint_position
	pin_joint.node_a = joint_body_a.get_path()
	pin_joint.node_b = joint_body_b.get_path()
	pin_joint.softness = 0.3
	add_child(pin_joint)
	return pin_joint

func create_rope_rigidbody(body_position: Vector2, body_rotation: float, size: Vector2):
	var rigidbody := RigidBody2D.new()
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = size
	collision_shape.shape = shape
	rigidbody.add_child(collision_shape)
	add_child(rigidbody)
	rigidbody.global_transform.origin = body_position
	rigidbody.rotation = body_rotation
	rigidbody.set_collision_layer_value(1, false)
	rigidbody.set_collision_mask_value(1, false)
	rigidbody.set_collision_layer_value(10, true)
	return rigidbody

func create_rope(start_pos: Vector2, end_pos: Vector2, start_body: PhysicsBody2D, end_body: PhysicsBody2D, n_segments: int = 15):
	var rigidbodies: Array[RigidBody2D] = []
	var rope_segment_size = Vector2((start_pos - end_pos).length() / n_segments, rope_thickness)
	var rope_segment_rotation = start_pos.angle_to_point(end_pos)
	for i in n_segments:
		rigidbodies.append(create_rope_rigidbody(
			Vector2(-((start_pos.x - end_pos.x) / n_segments) * i, -((start_pos.y - end_pos.y) / n_segments) * i) + start_pos,
			rope_segment_rotation,
			rope_segment_size,
			)
		)
	
	# First connect the start body to the first rigidbody
	create_pin_joint(start_body, rigidbodies[0], (start_body.global_position + rigidbodies[0].global_position) / 2)

	# Connect all rigidbodies to each other
	for i in range(n_segments - 1):
		create_pin_joint(rigidbodies[i], rigidbodies[i+1], (rigidbodies[i].global_position + rigidbodies[i+1].global_position) / 2)

	# Connect the last rigidbody to the end body
	create_pin_joint(rigidbodies[n_segments-1], end_body, (rigidbodies[n_segments-1].global_position + end_body.global_position) / 2)
