class_name ButtonComponent extends Node2D

@export var linked_door: DoorComponent
signal button_pressed
signal button_unpressed


func _on_button_pressed(body: Node2D):
	linked_door.open()
	button_pressed.emit()

func _on_button_released(body: Node2D):
	linked_door.close()
	button_unpressed.emit()
