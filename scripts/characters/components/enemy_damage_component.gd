extends Node
@export_group("References")
@export var damage_collider: CollisionObject2D
@export var owning_entity: Node
@export_group("")
@export var damage: float = 1
@export var damage_type: Enums.DamageType = Enums.DamageType.Enemy

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
		print("Error in enemy damage component script on object : ", owning_entity.name)

func _on_body_entered(body: Node2D):
	if body is Player:
		body.health_component.damage(damage, damage_type, owning_entity)
