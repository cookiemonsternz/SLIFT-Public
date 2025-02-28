extends Panel

@onready var item_display: Sprite2D = $ItemDisplay

@onready var area_2d: Area2D = $Area2D

@export var index: int
@export var side: int

var arm_upgrade: ArmUpgrade

var mouse_in_area := false

var dragging = false

var copy: Sprite2D = null

func update(item: ArmUpgrade):
	if !item:
		arm_upgrade = null
		item_display.visible = false
	else:
		arm_upgrade = item
		item_display.visible = true
		item_display.texture = item.texture

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.is_pressed():
		on_click()

func _process(delta: float) -> void:
	if dragging:
		copy.global_position = get_global_mouse_position()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			on_unclick()

func on_click():
	dragging = true
	# We create a copy for visuals
	
	copy = item_display.duplicate()
	copy.centered = true
	get_parent().add_child(copy)
	item_display.hide()
	
	#get_tree().get_first_node_in_group("Player").arm_upgrade_component.remove_upgrade(side, index)

func on_unclick():
	if dragging:
		#print("unclick")
		dragging = false
		item_display.show()
		copy.queue_free()
		get_hovering()

func get_hovering():
	for child in get_parent().get_parent().get_parent().get_child(0).get_child(0).get_children():
		if child is not Panel:
			continue
		#print(child)
		var area: Area2D = child.area_2d
		if child.mouse_in_area:
			get_tree().get_first_node_in_group("Player").arm_upgrade_component.add_upgrade(child.side, child.index, arm_upgrade)
			get_tree().get_first_node_in_group("Player").arm_upgrade_component.remove_upgrade_pool(arm_upgrade)
			queue_free()
			break

func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false
