extends Path2D

@export var speed_scale = 1
@export var do_rotation = false
@export var platform_body: AnimatableBody2D

@onready var path_follow = $PathFollow2D
@onready var animation_player = $AnimationPlayer
@onready var remote_transform = $PathFollow2D/RemoteTransform2D


func _ready() -> void:
	remote_transform.remote_path = platform_body.get_path()
	if !do_rotation:
		remote_transform.update_rotation = false
	if curve.get_point_position(0) == curve.get_point_position(curve.point_count-1):
		animation_player.play("move")
		animation_player.speed_scale = speed_scale
	else:
		print("NOT CLOSED")
		animation_player.play("move_l_r")
		animation_player.speed_scale = speed_scale
