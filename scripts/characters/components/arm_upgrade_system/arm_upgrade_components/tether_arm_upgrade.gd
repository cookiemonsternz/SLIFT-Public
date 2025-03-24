class_name TetherArmUpgrade extends ArmUpgrade

var loaded_texture: Texture = preload("res://assets/images/tether_arm_upgrade.png")

var physics_rope_scene: PackedScene = preload("res://scenes/characters/components/physics_rope.tscn")

var first_pos: Vector2
var first_body: PhysicsBody2D
var second_pos: Vector2
var second_body: PhysicsBody2D

func _init():
	texture = loaded_texture
	upgrade_name = "TetherArmUpgrade"

# Called once every process frame
# func update_process(player: Player, root: Node):
# 	pass

# Called once every physics frame
# func update_physics(player: Player, root: Node):
# 	pass

# Called when an arm is shot (not when it connects)
# func _on_arm_shot(side: int, player: Player, root: Node):
# 	pass

# Called when an arm connects (e.g the spring is created)
func _on_arm_connected(side: int, target_position: Vector2, target_body: PhysicsBody2D, player: Player, root: Node):
	if first_body == null:
		first_pos = target_position
		if (target_body.name == "DELETE_ME1" or target_body.name == "DELETE_ME2") or (not target_body is AnimatableBody2D or not target_body is RigidBody2D):
			first_body = create_static_body(target_position, root)
		else:
			first_body = target_body
	elif first_body != null:
		second_pos = target_position
		if (target_body.name == "DELETE_ME1" or target_body.name == "DELETE_ME2") or (not target_body is AnimatableBody2D or not target_body is RigidBody2D):
			second_body = create_static_body(target_position, root)
		else:
			second_body = target_body
			
		var physics_rope_instance = physics_rope_scene.instantiate()
		root.add_child(physics_rope_instance)
		#print(round(second_pos.distance_to(first_pos) / 50))
		physics_rope_instance.rigidbodies = physics_rope_instance.create_rope(second_pos, first_pos, first_body, second_body, round(second_pos.distance_to(first_pos) / 100))
		physics_rope_instance.start_end_pos = [second_pos, first_pos]
		first_body = null
		second_body = null


func create_static_body(body_position: Vector2, root: Node):
	var static_body = StaticBody2D.new()
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 50
	collision_shape.shape = shape
	static_body.add_child(collision_shape)
	static_body.global_position = body_position
	static_body.set_collision_layer_value(1, false)
	static_body.set_collision_mask_value(1, false)
	root.add_child(static_body)
	return static_body

# Called when an arm is released
#func _on_arm_released(side: int, player: Player, root: Node):
	#pass

# Called when the player recieves damage
# func _on_player_damaged(damage: float, damage_type: int, player: Player, root: Node):
# 	pass

# Called when the player lands
# func _on_player_landed(player: Player, root: Node):
# 	pass
