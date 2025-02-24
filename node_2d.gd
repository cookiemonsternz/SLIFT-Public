extends Path2D

@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
var switch = false


func _ready() -> void:
	if not loop:
		animation.play("move")
		animation.speed_scale = speed_scale

func _process(delta):
	if switch == false:
		path.progress += speed
	if switch == true:
		path.progress -= speed
