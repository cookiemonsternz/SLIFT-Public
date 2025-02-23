extends Line2D

### TODO ###
# Refactor to not have as many semi-redundant variables
# Think a lot could be local vars
# Also create a global enums lol

@export_group("References")
@export var grapple_origin: Node2D
@export var player: CharacterBody2D

@export_group("General Settings")
@export var side: Enums.Grapples
@export var precision: int = 40
@export_range(0, 20) var straighten_line_speed: float = 5

@export_group("Animation Settings")
@export var animation_curve: Curve
@export_range(0.01, 4) var start_wave_size: float = 2
@export_range(0.1, 30) var animation_scale: float = 5
var wave_size: float = 0

@export_group("Rope Progression")
@export var rope_progression_curve: Curve
@export_range(1, 50) var rope_progression_speed: float = 1

var move_time: float = 0

var is_grappling: bool = true

var enabled: bool = false

var straight_line: bool = true

func enable() -> void:
	move_time = 0
	wave_size = start_wave_size
	straight_line = false
	enabled = true
	line_points_to_grapple_origin()

func disable() -> void:
	enabled = false
	is_grappling = false
	straight_line = false
	self.points = []

# Initalizes the rope with all points at the grapple origin
func line_points_to_grapple_origin() -> void:
	self.points = []
	for i in range (0, precision):
		add_point(grapple_origin.global_position)

func _process(delta: float) -> void:
	if enabled:
		move_time += delta
		draw_rope(delta)

func draw_rope(delta: float) -> void:
	if not straight_line:
		if len(self.points) != 0:
			if to_global(points[len(points) - 1]).distance_to(player.grapple_target_markers[side].global_position) < 20:
				straight_line = true
				player.grapple(side)
			else:
				draw_rope_waves()
	else:
		if wave_size > 0:
			wave_size -= delta * straighten_line_speed
			draw_rope_waves()
		else:
			wave_size = 0
			if len(self.points) != 2:
				self.points = [grapple_origin.global_position, player.grapple_target_markers[side].global_position]
			draw_rope_no_waves()

func draw_rope_waves() -> void:
	for i in range (0, precision):
		var delta = float(i) / (precision - 1.0)
		var offset = perpendicular_vector(player.grapple_distance_vectors[side]).normalized() * animation_curve.sample_baked(delta) * wave_size
		var target_position = grapple_origin.global_position.lerp(player.grapple_target_markers[side].global_position, delta) + offset * animation_scale
		var current_position = grapple_origin.global_position.lerp(target_position, rope_progression_curve.sample_baked(move_time * rope_progression_speed))
		set_point_position(i, to_local(current_position))

func draw_rope_no_waves():
	set_point_position(0, to_local(grapple_origin.global_position))
	set_point_position(1, to_local(player.grapple_target_markers[side].global_position))


func perpendicular_vector(v: Vector2) -> Vector2:
	# rotate 90 degrees counter-clockwise
	return Vector2(v.y, -v.x)
