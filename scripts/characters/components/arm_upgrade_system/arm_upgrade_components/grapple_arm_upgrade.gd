class_name GrappleArmUpgrade extends ArmUpgrade

var loaded_texture: Texture = preload("res://assets/Images/grapple_arm_upgrade.png")

const launch_speed = 20
const damping = 0.9
const bias = 0

const rest_distance = 250


var spring_joint: DampedSpringJoint2D

func _init():
	texture = loaded_texture
	upgrade_name = "Grapple Arm Upgrade"

# Called once every process frame
func update_process(player: Player, _root: Node):
	match player.current_move_mode:
		Enums.MoveModes.AIR:
			player.global_position = player.player_physics_follow.global_position

# Called once every physics frame
# func update_physics(player: Player, root: Node):
# 	pass

# Called when an arm is shot (not when it connects)
# func _on_arm_shot(side: int, player: Player, root: Node):
# 	pass

# Called when an arm connects (e.g the spring is created)
func _on_arm_connected(_side: int, target_position: Vector2, target_body: PhysicsBody2D, player: Player, _root: Node):
	var grapple_distance_vector = player.global_position - target_position
	spring_joint = create_spring_joint(player.global_position, target_position, player.player_physics_follow, target_body, grapple_distance_vector.length(), grapple_distance_vector.length() - rest_distance)
	player.current_move_mode = Enums.MoveModes.AIR

# Called when an arm is released
func _on_arm_released(_side: int, _player: Player, _root: Node):
	if spring_joint != null:
		spring_joint.queue_free()

# Called when the player recieves damage
# func _on_player_damaged(damage: float, damage_type: int, player: Player, root: Node):
# 	pass

# Called when the player lands
func _on_player_landed(_player: Player, _root: Node):
	if spring_joint != null:
		spring_joint.queue_free()

func create_spring_joint(point_a: Vector2, point_b: Vector2, body_a: PhysicsBody2D, body_b: PhysicsBody2D, length: float, rest_length: float) -> DampedSpringJoint2D:
	
	# This stops the bug when if you spam grapples eventually it will try to set one of the nodes to null
	# This is possibly due to raycast2d inconsistencies?
	# TODO : Find a better solution
	if body_a == null or body_b == null:
		return DampedSpringJoint2D.new()
	var spring = DampedSpringJoint2D.new()
	
	# Need to set all length and other spring vars before attaching nodes or adding to tree

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
	
	body_a.get_tree().root.add_child(spring)
	
	return spring
