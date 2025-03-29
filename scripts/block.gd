@tool
extends Polygon2D

var do_add = false
var do_update = false
@export var create_colliders: bool :
	set(value):
		print("CREATING COLLIDERS")
		_on_create_colliders()
@export var delete_colliders: bool:
	set(value):
		print("DELETING COLLIDERS")
		_on_delete_colliders()
@export var update_colliders: bool:
	set(value):
		_on_update_colliders()	

var objects = []

func _on_create_colliders():
	color = Color(1.0, 1.0, 1.0, 0.0)
	var static_body := StaticBody2D.new()

	var light_occluder := LightOccluder2D.new()
	var sprite := Polygon2D.new()
	
	var occluder_polygon := OccluderPolygon2D.new()
	
	
	sprite.polygon = polygon
	occluder_polygon.polygon = polygon
	light_occluder.occluder = occluder_polygon

	
	self.add_child(static_body)
	self.add_child(light_occluder)
	self.add_child(sprite)
	static_body.owner = get_tree().edited_scene_root
	light_occluder.owner = get_tree().edited_scene_root
	sprite.owner = get_tree().edited_scene_root
	
	static_body.name = name + "StaticBody2D"
	light_occluder.name = name + "LightOccluder2D"
	sprite.name = name + "Polygon2D"
	do_add = true
	
	

func _on_delete_colliders():
	color = Color(1.0, 1.0, 1.0, 1.0)
	for child in get_children():
		child.queue_free()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if do_add:
			#print("HELLO")
			do_add = false
			var collision_shape := CollisionPolygon2D.new()
			collision_shape.polygon = polygon
			
			get_child(0).add_child(collision_shape)
			collision_shape.set_owner(get_tree().edited_scene_root)
			collision_shape.name = name + "CollisionPolygon2D"
			self.print_tree_pretty()
		if do_update:
			_on_update_colliders()
			do_update = false

func _on_update_colliders():
	_on_delete_colliders()
	_on_create_colliders()
