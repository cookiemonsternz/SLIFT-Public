extends ColorRect

@export_range(0.0, 5.0) var exposure: float = 1.0
@export var color_correction: GradientTexture1D

@export var tween_time: float = 3

@export var reset_on_exit: bool = true

var collision_shape: CollisionShape2D
var environment: WorldEnvironment

var cache_exposure: float
var cache_color_correction: GradientTexture1D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape = $Area2D/CollisionShape2D
	color = Color(0,0,0,0)
	var shape = RectangleShape2D.new()
	shape.size = size
	collision_shape.shape = shape
	collision_shape.position = size/2
	environment = get_tree().get_first_node_in_group("environment")
	cache_exposure = environment.environment.tonemap_exposure
	cache_color_correction = environment.environment.adjustment_color_correction




func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entered area")
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_method(set_exposure, environment.environment.tonemap_exposure, exposure, tween_time)
	var tween2 = get_tree().create_tween()
	
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_QUART)
	tween2.tween_method(set_color_correction, environment.environment.adjustment_color_correction, color_correction, tween_time)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not reset_on_exit: return;
	print("Exited Area")
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_method(set_exposure, environment.environment.tonemap_exposure, cache_exposure, tween_time)
	var tween2 = get_tree().create_tween()
	
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_QUART)
	tween2.tween_method(set_color_correction, environment.environment.adjustment_color_correction, cache_color_correction, tween_time)


func set_exposure(value: float):
	environment.environment.tonemap_exposure = value

func set_color_correction(value: GradientTexture1D):
	environment.environment.adjustment_color_correction = value
