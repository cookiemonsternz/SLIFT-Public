extends ColorRect

@export_custom(PROPERTY_HINT_LINK, "suffix:") var zoom_level := Vector2(3, 3)
@export_custom(PROPERTY_HINT_LINK, "suffix:") var offset := Vector2(0, 0)

@export var tween_time: float = 3

@export var reset_on_exit: bool = true

var collision_shape: CollisionShape2D
var camera: Camera2D

var cache_zoom: Vector2
var cache_offset: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape = $Area2D/CollisionShape2D
	color = Color(0,0,0,0)
	var shape = RectangleShape2D.new()
	shape.size = size
	collision_shape.shape = shape
	collision_shape.position = size/2
	camera = get_tree().get_first_node_in_group("camera")
	cache_zoom = camera.zoom
	cache_offset = camera.offset




func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entered area")
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(camera, "zoom", zoom_level, tween_time)
	var tween2 = get_tree().create_tween()
	
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_QUART)
	tween2.tween_property(camera, "offset", offset, tween_time)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not reset_on_exit: return;
	print("Exited Area")
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(camera, "zoom", cache_zoom, tween_time)
	var tween2 = get_tree().create_tween()
	
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_QUART)
	tween2.tween_property(camera, "offset", cache_offset, tween_time)
