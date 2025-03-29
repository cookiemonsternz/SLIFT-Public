class_name DoorComponent extends Node2D

@export var owning_entity: Node

@export_group("Door Visuals + Collider")
@export var door_animatable_body: AnimatableBody2D
@export var door_animation_manager: AnimationPlayer

@export_group("Tweening Visuals")
@export var use_tween := false
@export var open_position := Vector2.ZERO
@export var closed_position := Vector2.ZERO
@export var tween_duration: float = 3.0
@export var tween_easing_mode: Tween.EaseType = Tween.EaseType.EASE_IN
@export var tween_transition_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

var is_open: bool = false
signal door_opened
signal door_closed

func open(_a=null, _b=null, _c=null, _d=null, _e=null, _f=null):
	print("OPENEING : " + name)
	if not is_open:
		door_opened.emit()
		is_open = true
		if door_animatable_body != null and door_animation_manager != null and not use_tween:
			door_animation_manager.play("door_open")
		elif use_tween and door_animatable_body != null:
			print("OPENING")
			var position_tweener = get_tree().create_tween()
			position_tweener.tween_property(door_animatable_body, "position", open_position, tween_duration)\
				.set_trans(tween_transition_type)\
				.set_ease(tween_easing_mode)

func close():
	if is_open:
		door_closed.emit()
		is_open = false
		if door_animatable_body != null and door_animation_manager != null and not use_tween:
			door_animation_manager.play("door_close")
		elif use_tween and door_animatable_body != null:
			var position_tweener = get_tree().create_tween()
			position_tweener.tween_property(door_animatable_body, "position", closed_position, tween_duration)\
				.set_trans(tween_transition_type)\
				.set_ease(tween_easing_mode)
