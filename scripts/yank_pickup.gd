extends Node2D

var can_get: bool = false

func _process(delta: float) -> void:
	if can_get:
		$Sprite2D.visible = false
		$Sprite2D2.visible = false
		$Sprite2D3.visible = false
		$Sprite2D4.visible = true
		#queue_free()
	if (Input.is_action_just_pressed("grapple_left")):
		for i: PhysicsBody2D in $CanPickupArea.get_overlapping_bodies():
			if i.is_in_group("Player"):
				var player: Player = i
				player.arm_upgrade_component.add_upgrade(0, 0, YankArmUpgrade.new())
				can_get = true
	if (Input.is_action_just_pressed("grapple_right")):
		for i: PhysicsBody2D in $CanPickupArea.get_overlapping_bodies():
			if i.is_in_group("Player"):
				var player: Player = i
				player.arm_upgrade_component.add_upgrade(1, 0, YankArmUpgrade.new())
				can_get = true




func _on_display_input_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Sprite2D.visible = true
		$Sprite2D2.visible = true


func _on_display_input_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Sprite2D.visible = false
		$Sprite2D2.visible = false
