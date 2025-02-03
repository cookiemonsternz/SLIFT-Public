extends Node

@export_group("Health")
@export var max_health: float = 10
@export var health: float = 10
@export var health_regen_rate: float = 0.1
@export var health_regen_amount: float = 0.1

@export_group("Shield")
@export var max_shield: float = 10
@export var shield: float = 10
@export var shield_regen_rate: float = 0.1
@export var shield_regen_amount: float = 0.1

enum DamageType {
	World,
	Enemy,
	Obstacle,
	Light
}

signal creature_died

var health_regen_timer: Timer
var shield_regen_timer: Timer

func _ready() -> void:
	health_regen_timer = Timer.new()
	health_regen_timer.wait_time = health_regen_rate
	health_regen_timer.timeout.connect(_on_health_regen_timer_timeout)
	health_regen_timer.autostart = true
	self.add_child(health_regen_timer)
	
	shield_regen_timer = Timer.new()
	shield_regen_timer.wait_time = shield_regen_rate
	shield_regen_timer.timeout.connect(_on_shield_regen_timer_timeout)
	shield_regen_timer.autostart = true
	self.add_child(shield_regen_timer)

func damage(damage: float, damage_type: DamageType = DamageType.World):
	print(shield, " : ", health)
	match damage_type:
		DamageType.World:
			shield = shield - damage if shield > 0 else 0
			if shield == 0:
				health -= damage
				if health < 0:
					creature_died.emit()
		DamageType.Enemy:
			shield = shield - damage if shield > 0 else 0
			if shield == 0:
				health -= damage
				if health < 0:
					creature_died.emit()
		DamageType.Obstacle:
			shield = shield - damage if shield > 0 else 0
			if shield == 0:
				health -= damage
				if health < 0:
					creature_died.emit()
		DamageType.Light:
			shield = shield - damage if shield > 0 else 0
			if shield == 0:
				health -= damage
				if health < 0:
					creature_died.emit()
					get_parent().modulate = Color(1.0, 0.0, 0.0)
			

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
