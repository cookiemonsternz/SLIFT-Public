class_name ButtonComponent extends Node2D

@export var linked_door: DoorComponent

func _on_button_pressed(body: Node2D):
	linked_door.open()

func _on_button_released(body: Node2D):
	linked_door.close()
