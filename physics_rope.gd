extends Node2D

@export var rope_thickness = 5

var line_2d
var rigidbodies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rigidbodies != null:
		draw_rope(rigidbodies, line_2d)


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
	pin_joint.softness = 0.1
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
	
	# Calculate the direction vector from start to end
	var direction = end_pos - start_pos
	var segment_length = direction.length() / n_segments
	var normalized_direction = direction.normalized()
	var rope_segment_size = Vector2(segment_length, rope_thickness)
	var rope_segment_rotation = start_pos.angle_to_point(end_pos)
	
	# Create the rope segments with proper positioning
	for i in n_segments:
		var segment_position = start_pos + normalized_direction * segment_length * i
		rigidbodies.append(create_rope_rigidbody(
			segment_position,
			rope_segment_rotation,
			rope_segment_size
			)
		)
	
	# First connect the start body to the first rigidbody
	create_pin_joint(end_body, rigidbodies[0], (end_body.global_position + rigidbodies[0].global_position) / 2)
	# Connect all rigidbodies to each other
	for i in range(n_segments - 1):
		create_pin_joint(rigidbodies[i], rigidbodies[i+1], (rigidbodies[i].global_position + rigidbodies[i+1].global_position) / 2)
	# Connect the last rigidbody to the end body
	create_pin_joint(rigidbodies[n_segments-1], start_body, (rigidbodies[n_segments-1].global_position + start_body.global_position) / 2)
	
	create_line_2d()
	
	return rigidbodies

func create_line_2d():
	var line = Line2D.new()
	add_child(line)
	line_2d = line

func draw_rope(rigidbodies: Array[RigidBody2D], line2d: Line2D):
	if len(rigidbodies) > len(line2d.points):
		var cache_len = len(line2d.points)
		for i in range(len(rigidbodies) - len(line2d.points)):
			line2d.add_point(rigidbodies[i+cache_len].global_position)
	for i in len(rigidbodies):
		line2d.set_point_position(i, rigidbodies[i].global_position)
		
