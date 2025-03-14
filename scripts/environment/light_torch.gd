extends AnimatedSprite2D

@export var light_intensity_curve: Curve

func _ready():
	self_modulate = Color(0.0, 0.0, 0.0, 0.0)

func start_fire(_body):
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	play("start_fire")
	animation_finished.connect(play_loop)

func play_loop():
	play("loop_fire")
	set_frame_and_progress(8, 0)

func _physics_process(delta: float) -> void:
	if animation == "loop_fire" or animation == "start_fire":
		update_light()

func update_light():
	$PointLight2D.energy = light_intensity_curve.sample_baked(float(frame / 2) / float(sprite_frames.get_frame_count("loop_fire")))
