extends Node2D

@export var physics_body: PhysicsBody2D
@export var sprite: Sprite2D
@export var light_occluder: LightOccluder2D
@export var light: PointLight2D
@export var light_collider: Area2D
@export var light_origin: Marker2D

@export var light_damage: float = 1
@export var light_time: float = 0.1

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var raycast: RayCast2D = $RayCast2D

var bodies_in_light = []
var timers = {}

enum DamageType {
	World,
	Enemy,
	Obstacle,
	Light
}

func _ready() -> void:
	light_collider.body_entered.connect(_on_body_entered_light_collider)
	light_collider.body_exited.connect(_on_body_exited_light_collider)

func _process(delta: float) -> void:
	for body: PhysicsBody2D in bodies_in_light:
		if not timers.has(body):
			timers[body] = create_timer(damage_body.bind(body))

func damage_body(body: PhysicsBody2D):
	raycast.global_position = light_origin.global_position
	raycast.target_position = to_local(body.global_position)
	if not raycast.is_colliding():
		#print("damaging")
		body.health_component.damage(light_damage, DamageType.Light)

func create_timer(on_finish: Callable):
	var timer = Timer.new()
	timer.wait_time = light_time
	timer.autostart = true
	timer.timeout.connect(on_finish)
	add_child(timer)
	timer.start()
	return timer

func _on_body_entered_light_collider(body: PhysicsBody2D) -> void:
	print("HI")
	if body.is_in_group("Player"):
		bodies_in_light.append(body)
		print(timers, " : ", bodies_in_light)

func _on_body_exited_light_collider(body: PhysicsBody2D) -> void:
	if bodies_in_light.find(body) != -1:
		bodies_in_light.pop_at(bodies_in_light.find(body))
	if timers.has(body):
		if timers[body] != null:
			timers[body].queue_free()
			timers.erase(body)
	
