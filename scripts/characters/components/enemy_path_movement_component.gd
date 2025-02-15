extends Node

@export var owning_entity: Node2D
@export var speed: float = 5

@onready var path_follow_2d: PathFollow2D = owning_entity.path_follow_2d

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow_2d.progress += speed * delta
	owning_entity.global_position = path_follow_2d.global_position
