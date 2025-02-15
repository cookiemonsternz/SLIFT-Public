extends Node

@export var damage_collider: CollisionObject2D
@export var knockback_amount: float = 500

@export var knockback_origin: Marker2D

var queue_knockback = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if damage_collider == null:
		printerr("Damage collider is null")
		EngineDebugger.debug(false, false)
		return
	if damage_collider is Area2D:
		damage_collider.body_entered.connect(_on_body_entered)
	else:
		# ADD MORE IF YOU WANT TO USE RIGIDBODY / KINEMATIC BODY
		print("Error in enemy knockback component script on object : ", get_parent().name)

func _on_body_entered(body: Node):
	if body is Player:
		#print(-(knockback_origin.global_position - body.player_physics_follow.global_position).normalized())
		if body.current_move_mode == Enums.MoveModes.GROUND:
			body.current_move_mode = Enums.MoveModes.AIR
			body.global_position.y -= 30
		queue_knockback = body

func _physics_process(delta: float) -> void:
	if queue_knockback != null:
		var direction = -(knockback_origin.global_position - queue_knockback.player_physics_follow.global_position).normalized() * knockback_amount
		queue_knockback.player_physics_follow.apply_central_impulse(direction)
		queue_knockback = null
