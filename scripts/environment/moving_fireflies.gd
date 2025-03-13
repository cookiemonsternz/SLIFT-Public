extends GPUParticles2D

@export var target_locations: Array[Marker2D]
@export var tween_easing: Tween.EaseType
@export var tween_transition: Tween.TransitionType
@export var tween_length: float = 5.0

@export var auto_advance: bool = false
@export var auto_advance_interval: float = 0.5

var current_marker: int = 0


func _ready() -> void:
	move_to_next_marker()

func move_to_next_marker():
	var tween2 = create_tween()
	tween2.set_ease(tween_easing)
	tween2.set_trans(tween_transition)
	tween2.tween_method(set_gravity, Vector2(process_material.gravity.x, process_material.gravity.y), to_local(target_locations[current_marker].global_position).normalized() * 150, tween_length * 0.4)
	tween2.finished.connect(undo_speedup)
	
	var tween = create_tween()
	tween.tween_interval(tween_length * 0.1)
	tween.finished.connect(move_tween)
	
	if auto_advance:
		var tween3 = create_tween()
		tween3.tween_interval(tween_length + auto_advance_interval)
		tween3.finished.connect(move_to_next_marker)
		

func undo_speedup():
	var tween2 = create_tween()
	tween2.set_ease(tween_easing)
	tween2.set_trans(tween_transition)
	tween2.tween_method(set_gravity, Vector2(process_material.gravity.x, process_material.gravity.y), Vector2.ZERO, tween_length * 0.4)

func move_tween():
	var tween = create_tween()
	tween.set_ease(tween_easing)
	tween.set_trans(tween_transition)
	tween.tween_property(self, "global_position", target_locations[current_marker].global_position, tween_length * 0.8)
	
	if current_marker == len(target_locations) - 1:
		current_marker = 0
	else:
		current_marker += 1

func set_gravity(gravity: Vector2):
	process_material.gravity = Vector3(gravity.x, gravity.y, 0.0)
