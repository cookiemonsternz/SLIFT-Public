class_name HealthComponent extends Node

@export var owning_entity: Node

@export_group("Health")
@export var max_health: float = 10
@export var health: float = 10
@export var health_regen := true
@export var health_regen_rate: float = 0.1
@export var health_regen_amount: float = 0.1

@export_group("Shield")
@export var max_shield: float = 10
@export var shield: float = 10
@export var shield_regen := true
@export var shield_regen_rate: float = 0.1
@export var shield_regen_amount: float = 0.1

signal entity_died(damage, damage_type, damage_source)
signal entity_damaged(damage, damage_type, damage_source)

var health_regen_timer: Timer
var shield_regen_timer: Timer

# Should be able to be used on player, enemy, and breakable objects

func _ready() -> void:
	if health_regen:
		health_regen_timer = Timer.new()
		health_regen_timer.wait_time = health_regen_rate
		health_regen_timer.timeout.connect(_on_health_regen_timer_timeout)
		health_regen_timer.autostart = true
		self.add_child(health_regen_timer)
	if shield_regen:
		shield_regen_timer = Timer.new()
		shield_regen_timer.wait_time = shield_regen_rate
		shield_regen_timer.timeout.connect(_on_shield_regen_timer_timeout)
		shield_regen_timer.autostart = true
		self.add_child(shield_regen_timer)

func damage(damage_amount: float, damage_type: Enums.DamageType = Enums.DamageType.World, damage_source: Node = null):
	if owning_entity is Player:
		owning_entity.arm_upgrade_component.player_damaged(damage_amount, damage_type)
	
	entity_damaged.emit(damage_amount, damage_type, damage_source)
	
	match damage_type:
		Enums.DamageType.World:
			shield = shield - damage_amount if shield > 0 else 0
			if shield == 0:
				health -= damage_amount
				if health <= 0:
					entity_died.emit(damage_amount, damage_type, damage_source)
		Enums.DamageType.Enemy:
			shield = shield - damage_amount if shield > 0 else 0
			if shield == 0:
				health -= damage_amount
				if health <= 0:
					entity_died.emit(damage_amount, damage_type, damage_source)
		Enums.DamageType.Obstacle:
			shield = shield - damage_amount if shield > 0 else 0
			if shield == 0:
				health -= damage_amount
				if health <= 0:
					entity_died.emit(damage_amount, damage_type, damage_source)
		Enums.DamageType.Light:
			shield = shield - damage_amount if shield > 0 else 0
			if shield == 0:
				health -= damage_amount
				if health <= 0:
					entity_died.emit(damage_amount, damage_type, damage_source)

func _on_health_regen_timer_timeout():
	if health < max_health:
		health += health_regen_amount
	else:
		health = max_health

func _on_shield_regen_timer_timeout():
	if shield < max_shield:
		shield += shield_regen_amount
	else:
		shield = max_shield
