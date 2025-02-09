@tool
extends Node2D


@export var physics_body: PhysicsBody2D
@export var sprite: Sprite2D
@export var light_occluder: LightOccluder2D
@export var light: PointLight2D
@export var light_collider: Area2D
@export var light_origin: Marker2D

@export var light_damage: float = 1
@export var light_time: float = 0.1

@export var create_nodes: bool : 
	set(value):
		create_nodes = value
		create_the_nodes()
		create_nodes = false

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
	if not Engine.is_editor_hint():
		light_collider.body_entered.connect(_on_body_entered_light_collider)
		light_collider.body_exited.connect(_on_body_exited_light_collider)

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		for body: PhysicsBody2D in bodies_in_light:
			if not timers.has(body):
				timers[body] = create_timer(damage_body.bind(body))

func damage_body(body):
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

func _on_body_entered_light_collider(body) -> void:
	if not Engine.is_editor_hint():
		print("HI")
		if body.is_in_group("Player"):
			bodies_in_light.append(body)
			print(timers, " : ", bodies_in_light)

func _on_body_exited_light_collider(body) -> void:
	if not Engine.is_editor_hint():
		print("HI")
		if bodies_in_light.find(body) != -1:
			bodies_in_light.pop_at(bodies_in_light.find(body))
		if timers.has(body):
			if timers[body] != null:
				timers[body].queue_free()
				timers.erase(body)

func create_the_nodes():
	if self.has_node("StaticBody2D"):
		self.remove_child(self.get_node("StaticBody2D"))
	if self.has_node("Sprite2D"):
		self.remove_child(self.get_node("Sprite2D"))
	if self.has_node("LightOccluder2D"):
		self.remove_child(self.get_node("LightOccluder2D"))
	if self.has_node("PointLight2D"):
		self.remove_child(self.get_node("PointLight2D"))
	if self.has_node("Area2D"):
		self.remove_child(self.get_node("Area2D"))
	if self.has_node("Marker2D"):
		self.remove_child(self.get_node("Marker2D"))


	var static_bodyd = StaticBody2D.new()
	static_bodyd.set_name("StaticBody2D")
	var sprited = Sprite2D.new()
	sprited.set_name("Sprite2D")
	var light_occluderd = LightOccluder2D.new()
	light_occluderd.set_name("LightOccluder2D")
	var lightd = PointLight2D.new()
	lightd.set_name("PointLight2D")
	var aread = Area2D.new()
	aread.set_name("Area2D")
	var markerd = Marker2D.new()
	markerd.set_name("Marker2D")
	
	self.add_child(static_bodyd)
	self.add_child(sprited)
	self.add_child(light_occluderd)
	self.add_child(lightd)
	self.add_child(aread)
	self.add_child(markerd)
	static_bodyd.set_owner(self)
	sprited.set_owner(self)
	light_occluderd.set_owner(self)
	lightd.set_owner(self)
	aread.set_owner(self)
	markerd.set_owner(self)

	# var static_body_collision_shape = CollisionShape2D.new()
	# static_body_collision_shape.set_name("CollisionShape2D")
	# static_bodyd.add_child(static_body_collision_shape)
	# static_body_collision_shape.set_owner(static_bodyd)
	# var area_collision_shape = CollisionShape2D.new()
	# area_collision_shape.set_name("CollisionShape2D")
	# aread.add_child(area_collision_shape)
	# area_collision_shape.set_owner(aread)

	self.physics_body = static_bodyd
	self.sprite = sprited
	self.light_occluder = light_occluderd
	self.light = lightd
	self.light_collider = aread
	self.light_origin = markerd
