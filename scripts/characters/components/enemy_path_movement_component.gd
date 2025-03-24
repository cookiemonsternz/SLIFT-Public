extends Node

@export var owning_entity: Node2D
@export var speed: float = 5

@export var do_rotate: bool = false

@onready var path_follow_2d: PathFollow2D = owning_entity.path_follow_2d

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow_2d.progress += speed * delta
	owning_entity.global_position = path_follow_2d.global_position
	
	
	if path_follow_2d.global_rotation_degrees > 90 or path_follow_2d.global_rotation_degrees < -90:
		if do_rotate:
			owning_entity.global_rotation_degrees = path_follow_2d.global_rotation_degrees - 180
		owning_entity.scale = Vector2(-1, 1)
	else:
		owning_entity.scale = Vector2(1, 1)
		if do_rotate:
			owning_entity.global_rotation_degrees = path_follow_2d.global_rotation_degrees
	
	#if do_rotate:
		#owning_entity.global_rotation_degrees = clamp(owning_entity.global_rotation_degrees, -90, 90)
