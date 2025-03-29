extends Node2D

@export var upgrade: Script

var can_get: bool = false
var gotten: bool = false

func _ready():
	$Sprite2D3.texture = upgrade.new().texture

func _process(_delta: float) -> void:
	if gotten:
		if Input.is_action_just_pressed("arm_upgrade_ui"):
			print("IHIHIH")
			$Sprite2D4.create_tween().tween_property($Sprite2D4, "modulate", Color(1,1,1,0), 1.0)
	if can_get:
		#$Sprite2D.visible = false
		#$Sprite2D2.visible = false
		#$Sprite2D3.visible = false
		#$Sprite2D4.visible = true
		$Sprite2D.create_tween().tween_property($Sprite2D, "modulate", Color(1,1,1,0), 0.4)
		$Sprite2D2.create_tween().tween_property($Sprite2D2, "modulate", Color(1,1,1,0), 0.4)
		$Sprite2D3.create_tween().tween_property($Sprite2D3, "modulate", Color(1,1,1,0), 0.4)
		$Sprite2D4.create_tween().tween_property($Sprite2D4, "modulate", Color(1,1,1,1), 0.4)
		can_get = false
		gotten = true
		#queue_free()
		
			
	if (Input.is_action_just_pressed("interact")):
		for i: PhysicsBody2D in $CanPickupArea.get_overlapping_bodies():
			if i.is_in_group("Player"):
				var player: Player = i
				player.arm_upgrade_component.add_upgrade_pool(upgrade.new())
				can_get = true




func _on_display_input_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not can_get:
		$Sprite2D.create_tween().tween_property($Sprite2D, "modulate", Color(1,1,1,1), 1.0)
		$Sprite2D2.create_tween().tween_property($Sprite2D2, "modulate", Color(1,1,1,1), 1.0)


func _on_display_input_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and not can_get:
		$Sprite2D.create_tween().tween_property($Sprite2D, "modulate", Color(1,1,1,0), 1.0)
		$Sprite2D2.create_tween().tween_property($Sprite2D2, "modulate", Color(1,1,1,0), 1.0)
	elif body.is_in_group("Player") and can_get:
		print("HI")
		$Sprite2D4.create_tween().tween_property($Sprite2D4, "modulate", Color(1,1,1,0), 1.0)
