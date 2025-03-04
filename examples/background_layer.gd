class_name BackgroundLayer extends CanvasGroup

@export_category("motion")
@export_custom(PROPERTY_HINT_LINK, "suffix:m") var motion_scale := Vector2(1, 1)
@export var offset := Vector2(0,0)
@export var mirroring := Vector2(0,0)

var children: Array[Node]

var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	children = get_children()
	camera = get_tree().get_first_node_in_group("camera")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
