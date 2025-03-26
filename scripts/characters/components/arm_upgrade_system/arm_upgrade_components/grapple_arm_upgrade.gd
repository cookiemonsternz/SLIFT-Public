class_name GrappleArmUpgrade extends ArmUpgrade

var loaded_texture: Texture = preload("res://assets/images/grapple_arm_upgrade.png")

const launch_speed = 15
const damping = 0.9
const bias = 0

const rest_distance = 170

var cache_target

var spring_joint: DampedSpringJoint2D

func _init():
	texture = loaded_texture
	upgrade_name = "Grapple Arm Upgrade"

# Called once every process frame
func update_process(player: Player, _root: Node):
	match player.current_move_mode:
		Enums.MoveModes.AIR:
			player.global_position = player.player_physics_follow.global_position
			if spring_joint != null:
				var physics_follow_rotation = player.player_physics_follow.global_position.angle_to_point(cache_target) + PI/2
				player.global_rotation = move_toward(player.global_rotation, physics_follow_rotation, 2 * player.get_process_delta_time())
			else:
				var physics_follow_rotation = player.player_physics_follow.linear_velocity.angle()
				var max_rotation_angle = PI/6
				
				var rotation_sign = sign(player.player_physics_follow.linear_velocity.x)
				
				var angle_diff = wrapf(physics_follow_rotation - player.global_rotation, -PI, PI)
				
				angle_diff = clamp(angle_diff, -max_rotation_angle, max_rotation_angle) * rotation_sign
				
				player.global_rotation = wrapf(player.global_rotation + angle_diff * 2 * player.get_process_delta_time(), -PI, PI)
			
			if player.player_physics_follow.linear_velocity.x < 0:
				player.anim_sprite.flip_h = true
				player.anim_sprite.position = Vector2(22, 0)
			else:
				player.anim_sprite.flip_h = false
				player.anim_sprite.position = Vector2(0, 0)
			
		Enums.MoveModes.GROUND:
			player.global_rotation = 0
		Enums.MoveModes.DASH:
			player.global_rotation = 0

# Called once every physics frame
# func update_physics(player: Player, root: Node):
# 	pass

# Called when an arm is shot (not when it connects)
# func _on_arm_shot(side: int, player: Player, root: Node):
# 	pass

# Called when an arm connects (e.g the spring is created)
func _on_arm_connected(_side: int, target_position: Vector2, target_body: PhysicsBody2D, player: Player, _root: Node):
	if spring_joint != null:
		spring_joint.queue_free()
	var grapple_distance_vector = player.global_position - target_position
	spring_joint = create_spring_joint(player.global_position, target_position, player.player_physics_follow, target_body, grapple_distance_vector.length(), grapple_distance_vector.length() - rest_distance)
	player.current_move_mode = Enums.MoveModes.AIR
	player.set_anim_swinging(true)
	cache_target = target_position

# Called when an arm is released
func _on_arm_released(_side: int, player: Player, _root: Node):
	if spring_joint != null:
		spring_joint.queue_free()
		player.set_anim_swinging(false)
		player.anim_sprite.flip_h = false
		player.anim_sprite.position = Vector2(0, 0)

# Called when the player recieves damage
# func _on_player_damaged(damage: float, damage_type: int, player: Player, root: Node):
# 	pass

# Called when the player lands
func _on_player_landed(player: Player, _root: Node):
	if spring_joint != null:
		spring_joint.queue_free()
		player.anim_sprite.flip_h = false
		player.anim_sprite.position = Vector2(0, 0)

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
