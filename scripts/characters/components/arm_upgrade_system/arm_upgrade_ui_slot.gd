extends Panel

@onready var item_display: Sprite2D = $ItemDisplay

@export var index: int
@export var side: int
func update(item: ArmUpgrade):
	if !item:
		item_display.visible = false
	else:
		item_display.visible = true
		item_display.texture = item.texture


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.is_pressed():
		on_click()

func on_click():
	get_tree().get_first_node_in_group("Player").arm_upgrade_component.remove_upgrade(side, index)
